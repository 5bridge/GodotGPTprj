extends Node

var httpreq
var apiKeyText
var sayText
var sendButton
var answerText

# network
var url = "https://api.openai.com/v1/chat/completions"
var api_key

func _ready():
	print_debug("GPT is loading")
	
	httpreq = get_node("HTTPRequest") as HTTPRequest
	apiKeyText = get_node("GUI/Panel/ApiKeyTextLine") as LineEdit
	sayText = get_node("GUI/Panel/SayTextLine") as LineEdit
	sendButton = get_node("GUI/Panel/SendButton") as Button
	answerText = get_node("GUI/Panel/AnswerTextEdit") as TextEdit
	api_key = apiKeyText.text

func _on_send_button_pressed():
	var data_to_send = {
		"model": "gpt-3.5-turbo",
		"messages": [
			{
				"role": "system",
				"content": ""
			},
			{
				"role": "user",
				"content": sayText.text
			}
		],
		"temperature": 0.89,
		"max_tokens": 1024,
		"top_p": 1,
		"frequency_penalty": 0,
		"presence_penalty": 0
	}
	print(data_to_send)
	
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + api_key]
	httpreq.request(url, headers,HTTPClient.METHOD_POST, json)


func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var content = json["choices"][0]["message"]["content"]
	print(content)
	get_node("GUI/Panel/AnswerTextEdit").text = content
	
