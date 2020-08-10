from newsapi.newsapi_client import NewsApiClient
from newsapi.newsapi_exception import NewsAPIException
from flask import Flask
from flask import jsonify
import collections
import re
from flask import request
from datetime import date

app = Flask(__name__)


newsapi = NewsApiClient(api_key='ca88046c3ff441cb82ad8bea404e2b63')
top_headlines = newsapi.get_top_headlines(
                                      language='en',
                                      country='us')

CNNData = newsapi.get_everything(
                                     sources = 'CNN',
                                     language='en'
                                     )
foxData =  newsapi.get_everything(
                                    sources = 'fox-news',
                                    language='en'
                                    )

@app.route('/getTopHeadlines')
def gettopHeadlines() :
    removedData = []
    removedData = removeExtraValues(top_headlines)

    return jsonify(removedData)

@app.route('/getCNNData')
def getCNNData() :
    removedData = []
    removedData = removeExtraValues(CNNData)
    return jsonify(removedData)

@app.route('/getFoxNews')
def getFoxNews():
    removedData = []
    removedData = removeExtraValues(foxData)
    return jsonify(removedData)


@app.route('/getAllArticles')
def getAllArticles() :
    sources = request.args.get('source')
    toDate = request.args.get('toDate')
    fromDate=request.args.get('fromDate')
    keyword= request.args.get('keyword')
    category = request.args.get('category')
    all_articles =[]
    try :
        if sources != 'all':
            all_articles = newsapi.get_everything(q=keyword,
                                      sources=sources,
                                      from_param=fromDate,
                                      to=toDate,
                                      language='en',
                                      sort_by='publishedAt',
                                      page_size = 30
                                      )
        else :
            all_articles = newsapi.get_everything(q=keyword,
                                             from_param=fromDate,
                                             to=toDate,
                                             language='en',
                                             sort_by='publishedAt',
                                             page_size = 30
                                             )
            
        print(all_articles)
        removedData = removeExtraValues(all_articles)

    except NewsAPIException as e :
            return jsonify(['ErrorMessage',e.get_message()])
    return  jsonify(removedData)

@app.route('/getSources')
def getSources() :
    category = request.args.get('category')
    if category != 'all' :
        sources = newsapi.get_sources(category=category,language='en',
        country='us')
    else :
        sources = newsapi.get_sources()
    
    return jsonify(sources)

def removeExtraValues(main_list) :
    articles = main_list['articles']
    removedlist = []
    for main in articles :
        if main['source'] != None or len(main['source'] !=0 or main['source'] == 'null') :
            source = main['source']
            if source['name'] == None  or len(source['name']) == 0 or source['name'] == 'null' :
                continue
        else :
            continue

        if main['author'] == None or len(main['author']) ==0  or main['author'] == 'null' :
             continue
        if main['title'] == None or len(main['title']) ==0 or main['title'] == 'null'  :
             continue
        if main['description'] == None or len(main['description']) ==0 or main['description'] == 'null' :
             continue
        if main['url'] == None or len(main['url']) ==0  or main['url'] == 'null' :
            continue
        if main['urlToImage'] == None or len(main['urlToImage'])  ==0  or main['urlToImage'] == 'null' :
            continue
        if main['publishedAt'] == None or len(main['publishedAt']) ==0   or main['publishedAt'] == 'null':
            continue
        if main['content'] == None or len(main['content']) ==0 or main['content'] == 'null' :
            continue
        removedlist.append(main)
    return removedlist

@app.route('/getWordsList')
def getWordsList() :
    removedData = removeExtraValues(top_headlines)
#    removedData = removedData[:5]
    i = 0
    titles = ""
    for data in removedData :
        titles = titles + " "+str(data['title'])
        i = i +1
    f= open("stopwords_en.txt","r")
    stopwords = f.read().split("\n")
    if not 'to' in stopwords:
        print("Aishwarya")
    else:
        print("Prateek")
    print(stopwords)
    wordlist = re.split("[\' \n\t\r.,;:!?(){]",titles)
    dictionary = {}
    for word in wordlist:
        word = word
        if not word in stopwords and word != "-" and word != "&":
            #   print(word)
            if word in dictionary.keys():
                dictionary[word] = dictionary[word] + 1
            else:
                dictionary[word] = 1
    
    wordlist = list(dictionary.keys())
    wordfreq = list(dictionary.values())
    freq_list = []
    for i in range(len(wordlist)):
        dict1 = collections.OrderedDict()
        if  {"text": wordlist[i],"size": wordfreq[i]} not in freq_list :
            if len(wordlist[i]) != 0 :
                dict1["text"] = wordlist[i];
                dict1["size"] = wordfreq[i];
                freq_list.append(dict1)
        
    freq_list = sorted(freq_list, key=lambda r:r['size'], reverse=True)

    if(len(freq_list) < 30) :
        return jsonify(freq_list)
    return  jsonify(freq_list[:30])

@app.route('/')
def get_index() :
    return app.send_static_file('hw6.html')
##    return "Hello World"
#
if __name__ == "__main__" :
    app.debug =True
    app.run()




