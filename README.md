# GithubProfile
Github profile detail retrieving using GraphQL


Hi,

In order to use this application, please follow the given instruction

1. Clone this repo from any SVN tool or xcode itself. once the cloning process completed, Open the teminal and navigate to project folder and execute pod install to download dependancies for this application.
2. you need to obtain a token from github account. You can do this by going to your github account -> Settings - > Developer settings. Once you entered to developer setting page select personal access tokens section. Here you can create a new token by giving a name, make sure to copy this token, otherwise you will not be able to read it.
 
![image](https://user-images.githubusercontent.com/22807856/121880649-e4bfe080-cd2b-11eb-8026-c3863bcc45db.png)

3. Once you get your token, you need to open the application from xcode and navigate to NetworkManager class. There you will see a variable falled "ACCESS_TOKEN". Replace your token with existing one. 

![image](https://user-images.githubusercontent.com/22807856/121880854-22246e00-cd2c-11eb-8aaf-1112016362b7.png)

4. In order to retrive someone or your github profile info, you need to navigate to DataManager.swift file and change the gitName. Volla thats it.

![image](https://user-images.githubusercontent.com/22807856/121881028-54ce6680-cd2c-11eb-98ec-aae93b1447be.png)


Thank you
