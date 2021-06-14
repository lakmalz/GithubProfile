# GithubProfile
Github profile detail retrieving using GraphQL


![Simulator Screen Shot - iPhone 11 - 2021-06-14 at 20 27 36](https://user-images.githubusercontent.com/22807856/121913413-01214480-cd4f-11eb-97a3-8058b875511f.png)



![Simulator Screen Shot - iPhone 11 - 2021-06-14 at 20 28 36](https://user-images.githubusercontent.com/22807856/121913553-1f874000-cd4f-11eb-962c-4ab25bcd20a7.png)



Hi,

In order to use this application, please follow the given instruction

1. Clone this repo from any SVN tool or xcode itself. once the cloning process completed, Open the teminal and navigate to project folder and execute pod install to download dependancies for this application.
2. you need to obtain a token from github account. You can do this by going to your github account -> Settings - > Developer settings. Once you entered to developer setting page select personal access tokens section. Here you can create a new token by giving a name, make sure to copy this token, otherwise you will not be able to read it.
 
![image](https://user-images.githubusercontent.com/22807856/121880649-e4bfe080-cd2b-11eb-8026-c3863bcc45db.png)

3. Once you get your token, you need to open the application from xcode and navigate to Constant file which is inside the helper folder. There you have a variable called "ACCESS_TOKEN". Replace your token with existing one. Also set the github name you want to retrieve data

![Screenshot 2021-06-14 at 19 27 04](https://user-images.githubusercontent.com/22807856/121905183-8143ac00-cd47-11eb-954d-ee200c690c9e.png)


**Follwoing criteria has beeen fullfilled**U
1. Usage of MVP architecture
2. Used SnapKit for UI layouting
3. iOS version set to 11 or higher
4. Unit testing done for business layer (ProfilePresenter)
5. Pull to refresh implemented to refresh cached data
6. Caching data implemented for 1 day.



Thank you
