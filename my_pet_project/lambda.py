print('Loading function')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    print("value1 = key1")
    return 'key1'  # Echo back the first key value
    #raise Exception('Something went wrong')