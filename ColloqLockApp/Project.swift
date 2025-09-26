import ProjectDescription

let project = Project(
    name: "ColloqLockApp",
    packages: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.3.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        .target(
            name: "ColloqLockApp",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.ColloqLockApp",
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([
                    "UIColorName": .string(""),
                    "UIImageName": .string("")
                ]),
                "UIApplicationSceneManifest": .dictionary([
                    "UIApplicationSupportsMultipleScenes": .boolean(false),
                    "UISceneConfigurations": .dictionary([
                        "UIWindowSceneSessionRoleApplication": .array([
                            .dictionary([
                                "UISceneConfigurationName": .string("Default Configuration"),
                                "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                            ])
                        ])
                    ])
                ])
            ]),
            sources: ["ColloqLockApp/Sources/**"],
            resources: ["ColloqLockApp/Resources/**"],
            dependencies: [
                .package(product: "FirebaseAnalytics"),
                .package(product: "FirebaseAnalyticsCore"),
                .package(product: "FirebaseAnalyticsIdentitySupport"),
                .package(product: "FirebaseAuth"),
                .package(product: "FirebaseAppCheck"),
                .package(product: "FirebaseCrashlytics"),
                .package(product: "FirebaseDatabase"),
                .package(product: "FirebaseFirestore"),
                .package(product: "FirebaseFunctions"),
                .package(product: "FirebaseInAppMessaging-Beta"),
                .package(product: "FirebaseInstallations"),
                .package(product: "FirebaseMessaging"),
                .package(product: "FirebaseMLModelDownloader"),
                .package(product: "FirebasePerformance"),
                .package(product: "FirebaseRemoteConfig"),
                .package(product: "FirebaseStorage"),

                .package(product: "GoogleSignIn"),
            ]
        ),
        .target(
            name: "ColloqLockAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.ColloqLockAppTests",
            infoPlist: .default,
            sources: ["ColloqLockApp/Tests/**"],
            dependencies: [
                .target(name: "ColloqLockApp")
            ]
        ),
    ]
)
