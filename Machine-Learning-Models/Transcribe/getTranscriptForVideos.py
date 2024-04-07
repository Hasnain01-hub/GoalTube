from youtube_transcript_api import YouTubeTranscriptApi
import json

def getTranscriptOfAVideo(videoId):
    transcripts = YouTubeTranscriptApi.get_transcript(video_id=videoId)
    result = ""
    
    for transcript in transcripts:
        
        transcript = json.dumps(transcript)
        temp_transcript = json.loads(transcript)
        
        result = result + " " + (temp_transcript['text'])

    print(type(result))
    return result

def getTranscriptForPlaylist(videosIDs): #["id1". "id2"]
    result = ""
    print(videosIDs)
    print("HERERER")
    for videoId in videosIDs:
        print(videoId)
        result = result + " " + (getTranscriptOfAVideo(videoId))
    
    return result