struct User {
    var name: String
    var mail: String
    var age: Int
}

var userArray = [User]()

userArray.append(User(name: "Volker", mail: "abscsd", age: 10))
userArray.append(User(name: "Volker2", mail: "abscsffdgsd", age: 11))
userArray.append(User(name: "Volker3", mail: "abscasddsd", age: 12))
userArray.append(User(name: "Volker4", mail: "abscsdsd", age: 13))
userArray.append(User(name: "Volker5", mail: "absc", age: 14))

print(userArray)

var userShort = [String]()

var transform = userArray.map { user in
    userShort.append(user.name)

}

print(userShort)

print(userShort[2])
