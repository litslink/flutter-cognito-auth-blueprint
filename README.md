## Overview
It is a blueprint application. This application should be used as an example for your future projects. We are open for new ideas and proposals. If you want to add new features or modify existing components then just make a PR.

Application contains following features:
* Sign in/up using email or phone number + password. Application uses AWS Cognito authentication service as BE.
* Basic user information (email, name, notification settings) is stored as user attributes in Cognito user pool.
## Getting started
Before run project you should:
1. Create a user pool in Cognito. You can set any user attribute as required, but this project implies you don't have any.
2. Create an identity pool. In Authentication providers section choose Cognito tab and link this new identity pool with your user pool by providing your user pool id and app client id. 
3. Application uses this flutter plugin [Plugin](https://pub.dev/packages/flutter_cognito_plugin) for working with Cognito. You'll need to set up Amplify CLI and generate config files. Read plugin documentation thoroughly.
4. Create a bucket in S3. You'll need to configure access permissions in order to be able to download stored images.

[Article](https://docs.aws.amazon.com/cognito/latest/developerguide/tutorial-create-user-pool.html) with step by step user pool set up.

## BLoC state management.
BLoC (business logic component) is an architecture pattern. BLoC is a simple pipeline with logic inside. It receives events from UI and provides stream of states back to UI.

We recommend using the [BLoC library](https://bloclibrary.dev/#/gettingstarted) which provide a set of required widgets and base Bloc class.

![BLoC architecture](diagrams/bloc_diagram.png)
* **(1) States stream**. Use a `BlocBuilder` widget which contains subscriptions to state changes under the hood.

**Note:** You can use any type as a state. It can be `enum`, primitive, `class` or `abstract class`.

* **(2) Events stream**. Add new event from UI to Bloc object. Inside Bloc it event will be mapped to a new state or state sequence.

**Note 1:** Use `BlocProvider` to create new bloc instance. It widget cover lifecycle cases of widget. Be sure what your bloc instance will not be changed during next call of `build()` method.

**Note 2:** Use `BlocListener` to notify UI about side effects. Also you can use `BlocConsumer` which combines `BlocBuilder` and `BlocListener`.

Example of `BlocListener` + `BlocProvider` combination:
```dart
BlocListener<PhoneSignInBloc, PhoneSignInState>(
              bloc: _phoneSignInBloc,
              listener: (context, state) {
                //side effects
              },
              child: BlocBuilder<PhoneSignInBloc, PhoneSignInState>(
                bloc: _phoneSignInBloc,
                builder: (context, state) {
                  //return widget depend to state type
                },
              ),
            )
```

**Note 3:** The same as a state, any type can be your event.

* **(3, 4) Data request/response**. Bloc is a bridge between your data and UI. Each iteration with data should be located inside the bloc class. Such as data fetching, data modification or observing of data changes.

**Note:** You can add new events directly from the block. It will be useful if you want to observe data changes.
## Libraries stack
* **Dependency injection**. Use a [Provider](https://pub.dev/packages/provider) library which allows you to implement DI inside your application. It is a member of `Flutter favorite`. It means that the package is recommended by the official Flutter team.
* [**Equatable**](https://pub.dev/packages/equatable). Forget about overriding of `hashCode` and `==` methods when you need to compare objects.
* [**Flutter Cognito Plugin**](https://pub.dev/packages/flutter_cognito_plugin). Plugin for the communication with AWS Cognito.
* [**amazon_s3_cognito**](https://pub.dev/packages/amazon_s3_cognito). Library for uploading files to Amazon S3.
* [**Google sign in**](https://pub.dev/packages/google_sign_in). Provides ability to sign in using a Google account.

## Code style
We use [Effective Dart](https://dart.dev/guides/language/effective-dart) rules options. Also we use special `strong-mode` rules to avoid unexpected issues related to type casting.
```yaml
analyzer:
  exclude: [build/**]
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```


