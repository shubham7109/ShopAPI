# Shop API - Cyr3con

A simple shop API with two kinds of items. Initially 20 units of the first item, and 10 of the second one
## FrontEnd demo: https://shubham7109.github.io/ShopAPI

### Api Information:
API is hosted using Google Cloud App Engine.
- Display the summary of the current units available. [GET]
	> [https://shopapi-290308.uc.r.appspot.com/getSummary](https://shopapi-290308.uc.r.appspot.com/getSummary)
- Make purchase and get purchase details. [POST]
	> [https://shopapi-290308.uc.r.appspot.com/putItems](https://shopapi-290308.uc.r.appspot.com/putItems)
	> PUT request body argument example:

```
[
    {
        "id": 1,
        "itemName": "Item 1",
        "itemStock": 5
    },
    {
        "id": 2,
        "itemName": "Item 2",
        "itemStock": 3
    }
]
``` 
	
- Reset the database. Automatically called when refreshing frontend [GET]
	> [https://shopapi-290308.uc.r.appspot.com/reset](https://shopapi-290308.uc.r.appspot.com/reset)

### BackEnd Information:

The backend was developed using SpringBoot and Java. The MainController.java is located [here]([https://github.com/shubham7109/ShopAPI/blob/master/backend/src/main/java/com/cyr3con/backend/MainController.java](https://github.com/shubham7109/ShopAPI/blob/master/backend/src/main/java/com/cyr3con/backend/MainController.java))

### FrontEnd Information:
The FrontEnd was developed using the Dart and Flutter Web dev tools. Flutter supports the generation of web content rendered using standards-based web technologies: HTML, CSS and JavaScript. The main.dart file is located [here]([https://github.com/shubham7109/ShopAPI/blob/master/shop_app/lib/main.dart](https://github.com/shubham7109/ShopAPI/blob/master/shop_app/lib/main.dart)).

#### For more questions email: shubham@websharma.com
