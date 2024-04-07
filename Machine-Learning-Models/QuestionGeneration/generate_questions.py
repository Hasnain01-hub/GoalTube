from Questgen import main
from pprint import pprint
import nltk
nltk.download('stopwords')

# Generate boolean (Yes/No) Questions
# qe = main.BoolQGen()
# payload = {
#     "input_text": "Sachin Ramesh Tendulkar is a former international cricketer from India and a former captain of the Indian national team. He is widely regarded as one of the greatest batsmen in the history of cricket. He is the highest run scorer of all time in International cricket."
# }
# output = qe.predict_boolq(payload)
# pprint(output)

qg = main.QGen()

''' Generate MCQ Questions '''


def generateMCQQuestions(input_text):
    print("HRERE1")
    print(input_text)
    payload = {
        "input_text": input_text
    }
    # print(payload)
    output = qg.predict_mcq(payload)
    # pprint(output)
    return output

# # Generate FAQs
# output = qg.predict_shortq(payload)
# pprint(output)

# # Paraphrasing Questions
# payload2 = {
#     "input_text": "What is Sachin Tendulkar profession?",
#     "max_questions": 5
# }

# output = qg.paraphrase(payload2)
# print("Output :")
# pprint(output)
