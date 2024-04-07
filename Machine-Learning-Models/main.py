from flask import request
from flask import Flask

from RecommendationSystem.generate_recommendations import *
from QuestionGeneration.generate_questions import generateMCQQuestions
from Transcribe.getTranscriptForVideos import *

app = Flask(__name__)


@app.route('/get_youtube_recommendations',  methods=['POST'])
def generateRecommendations():
    print(request.data)
    try:
        return send_youtube_recommendations(request.data)
    except:
        return "something went wrong!"


@app.route("/generate_questions", methods=["POST"])
def getQuestionsFromQuesGen():
    try:
        transcript = getTranscriptForPlaylist((json.loads(request.data))['videos'])
        print("HRERE2")

        # print(transcript)
        final_result = generateMCQQuestions(transcript)
        # print(final_result)
        return final_result
    except Exception as e:
        print(e)
        return "Something went wrong!"


if __name__ == "__main__":
    app.run()
