from flask import Flask, session, redirect, request, render_template, url_for
import json
from check_login import check_login
from firebase_crud import *

app = Flask(__name__)
app.secret_key = "goal_tube_admin_panel_website"

with open("config.json", "r") as c:
    params = json.load(c)['params']


@app.route("/", methods=["GET", "POST"])
def login():
    # if user is logged in
    if ('user' in session and session['user'] == params['admin_user']):
        return redirect("/users")

    # If user requests to log in
    if request.method == "POST":
        # Redirect to Admin Panel
        username = request.form.get('uname')
        userpassword = request.form.get('pass')
        if (username == params['admin_user'] and userpassword == params['admin_password']):
            session['user'] = username
            return redirect("/users")

    return render_template("login.html", params=params)

@app.route("/users")
@check_login
def users():
    usersData = fetchUsers()
    return render_template("users.html", params=params, users=usersData,  active="brokers")


@app.route("/user/<email>", methods=["GET", "POST"])
@check_login
def individualUser(email):
    user = fetchUser(email)
    return render_template("single_user.html", params=params, user=user, active="brokers")

@app.route("/approveCourse", methods=["GET", "POST"])
@check_login
def convertlead():
    print(request.args)
    email =  request.args.get('email')
    index = request.args.get('index')
    value = request.args.get('value')
    approveCourse(email, index, value)
    return redirect("/user/"+email)

@app.route("/contacts")
@check_login
def contacts():
    contacts = fetchContacts()
    return render_template("contacts.html", params=params, contacts=contacts,  active="contacts")


@app.route("/logout")
def logout():
    session.pop('user')
    session.clear()
    return redirect("/")

# ==================================================================================================================


if __name__ == '__main__':
    app.run(debug=True)
