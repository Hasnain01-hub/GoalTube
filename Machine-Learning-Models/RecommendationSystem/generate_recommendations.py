# Implementation of RAKE - Rapid Automatic Keyword Exraction algorithm

import re
import operator
import requests
import json
from flask import request

debug = False
test = True

def is_number(s):
    try:
        float(s) if '.' in s else int(s)
        return True
    except ValueError:
        return False


def load_stop_words(stop_word_file):
    """
    Utility function to load stop words from a file and return as a list of words
    @param stop_word_file Path and file name of a file containing stop words.
    @return list A list of stop words.
    """
    stop_words = []
    for line in open(stop_word_file):
        if line.strip()[0:1] != "#":
            for word in line.split():  # in case more than one per line
                stop_words.append(word)
    return stop_words


def separate_words(text, min_word_return_size):
    """
    Utility function to return a list of all words that are have a length greater than a specified number of characters.
    @param text The text that must be split in to words.
    @param min_word_return_size The minimum no of characters a word must have to be included.
    """
    splitter = re.compile('[^a-zA-Z0-9_\\+\\-/]')
    words = []
    for single_word in splitter.split(text):
        current_word = single_word.strip().lower()
        # leave numbers in phrase, but don't count as words, since they tend to invalidate scores of their phrases
        if len(current_word) > min_word_return_size and current_word != '' and not is_number(current_word):
            words.append(current_word)
    return words


def split_sentences(text):
    """
    Utility function to return a list of sentences.
    @param text The text that must be split in to sentences.
    """
    sentence_delimiters = re.compile(
        u'[.!?,;:\t\\\\"\\(\\)\\\'\u2019\u2013]|\\s\\-\\s')
    sentences = sentence_delimiters.split(text)
    return sentences


def build_stop_word_regex(stop_word_file_path):
    stop_word_list = load_stop_words(stop_word_file_path)
    stop_word_regex_list = []
    for word in stop_word_list:
        word_regex = r'\b' + word + r'(?![\w-])'  # added look ahead for hyphen
        stop_word_regex_list.append(word_regex)
    stop_word_pattern = re.compile(
        '|'.join(stop_word_regex_list), re.IGNORECASE)
    return stop_word_pattern


def generate_candidate_keywords(sentence_list, stopword_pattern):
    phrase_list = []
    for s in sentence_list:
        tmp = re.sub(stopword_pattern, '|', s.strip())
        phrases = tmp.split("|")
        for phrase in phrases:
            phrase = phrase.strip().lower()
            if phrase != "":
                phrase_list.append(phrase)
    return phrase_list


def calculate_word_scores(phraseList):
    word_frequency = {}
    word_degree = {}
    for phrase in phraseList:
        word_list = separate_words(phrase, 0)
        word_list_length = len(word_list)
        word_list_degree = word_list_length - 1
        # if word_list_degree > 3: word_list_degree = 3 #exp.
        for word in word_list:
            word_frequency.setdefault(word, 0)
            word_frequency[word] += 1
            word_degree.setdefault(word, 0)
            word_degree[word] += word_list_degree  # orig.
            # word_degree[word] += 1/(word_list_length*1.0) #exp.
    for item in word_frequency:
        word_degree[item] = word_degree[item] + word_frequency[item]

    # Calculate Word scores = deg(w)/frew(w)
    word_score = {}
    for item in word_frequency:
        word_score.setdefault(item, 0)
        # orig.
        word_score[item] = word_degree[item] / (word_frequency[item] * 1.0)
    # word_score[item] = word_frequency[item]/(word_degree[item] * 1.0) #exp.
    return word_score


def generate_candidate_keyword_scores(phrase_list, word_score):
    keyword_candidates = {}
    for phrase in phrase_list:
        keyword_candidates.setdefault(phrase, 0)
        word_list = separate_words(phrase, 0)
        candidate_score = 0
        for word in word_list:
            candidate_score += word_score[word]
        keyword_candidates[phrase] = candidate_score
    return keyword_candidates


def generate_youtube_recommendations(query_text):
    # import OS for environment variables
    search_url = 'https://www.googleapis.com/youtube/v3/search'
    video_url = 'https://www.googleapis.com/youtube/v3/videos'

    videos = []

    search_params = {
        'key': 'AIzaSyBzp7VBXI9e4kh5qOm-pw7oveJ7ZYrRUgI',
        'q': query_text,
        'part': 'snippet',
        'maxResults': 3,
        'type': 'video'
    }

    r = requests.get(search_url, params=search_params)

    results = r.json()['items']

    video_ids = []
    for result in results:
        video_ids.append(result['id']['videoId'])

    video_params = {
        'key': 'AIzaSyBzp7VBXI9e4kh5qOm-pw7oveJ7ZYrRUgI',
        'id': ','.join(video_ids),
        'part': 'snippet,contentDetails',
        'maxResults': 4
    }

    r = requests.get(video_url, params=video_params)
    results = r.json()['items']

    for result in results:
        video_data = {
            'id': result['id'],
            'url': f'https://www.youtube.com/watch?v={ result["id"] }',
            'thumbnail': result['snippet']['thumbnails']['high']['url'],
            'duration': 0,
            'title': result['snippet']['title'],
        }
        videos.append(video_data)

    # print(videos)
    return videos


class Rake(object):
    def __init__(self, stop_words_path):
        self.stop_words_path = stop_words_path
        self.__stop_words_pattern = build_stop_word_regex(stop_words_path)

    def run(self, text):
        sentence_list = split_sentences(text)

        phrase_list = generate_candidate_keywords(
            sentence_list, self.__stop_words_pattern)

        word_scores = calculate_word_scores(phrase_list)

        keyword_candidates = generate_candidate_keyword_scores(
            phrase_list, word_scores)

        sorted_keywords = sorted(keyword_candidates.items(
        ), key=operator.itemgetter(1), reverse=True)
        return sorted_keywords




def send_youtube_recommendations(data):
    # history = ["Compatibility of systems of linear", " constraints over the set of natural numbers", "Criteria of compatibility of a system of linear Diophantine equations,", "strict inequations, and nonstrict inequations are considered.", "Upper bounds for components of a minimal", "set of solutions and algorithms of construction of minimal generating sets of solutions", "for all types of systems are given. These criteria ", "and the corresponding algorithms for constructing a minimal supporting ", "set of solutions can be used in solving all the considered types of ","systems and systems of mixed types."]
    print(data)

    history = json.loads(data)
    print(history)
    text = " ".join(history['data'])

    # Split text into sentences
    sentenceList = split_sentences(text)
    # stoppath = "FoxStoplist.txt" #Fox stoplist contains "numbers", so it will not find "natural numbers" like in Table 1.1
    # SMART stoplist misses some of the lower-scoring keywords in Figure 1.5, which means that the top 1/3 cuts off one of the 4.0 score words in Table 1.1
    stoppath = "SmartStoplist.txt"
    stopwordpattern = build_stop_word_regex(stoppath)

    # generate candidate keywords
    phraseList = generate_candidate_keywords(sentenceList, stopwordpattern)
    print("333")
    # calculate individual word scores
    wordscores = calculate_word_scores(phraseList)

    # generate candidate keyword scores
    keywordcandidates = generate_candidate_keyword_scores(
        phraseList, wordscores)
    if debug:
        print(keywordcandidates)

    sortedKeywords = sorted(keywordcandidates.items(),
                            key=operator.itemgetter(1), reverse=True)
    if debug:
        print(sortedKeywords)

    totalKeywords = len(sortedKeywords)
    if debug:
        print(totalKeywords)
    # print(sortedKeywords[0:(totalKeywords / 3)])
    # print(sortedKeywords[0:3])

    rake = Rake("SmartStoplist.txt")
    keywords = rake.run(text)
    print(keywords)

    recommendations__keyword_1 = generate_youtube_recommendations(
        keywords[0][0])
    recommendations__keyword_2 = generate_youtube_recommendations(
        keywords[1][0])
    recommendations__keyword_3 = generate_youtube_recommendations(
        keywords[3][0])

    result = (recommendations__keyword_1 + recommendations__keyword_2 + recommendations__keyword_3)
    return result



