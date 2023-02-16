// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

/**
 @brief Utility class for constructing OAuth Sign In credentials.
 */
// TODO: Swift FederatedAuthProvider with a sync and async version.
@objc(FIROAuthProvider) open class OAuthProvider: NSObject, FederatedAuthProvider {
  @objc public static let id = "OAuth"

  /**
      @param providerID The provider ID of the IDP for which this auth provider instance will be
          configured.
      @return An instance of `OAuthProvider` corresponding to the specified provider ID.
   */
  @objc(providerWithProviderID:) public class func provider(providerID: String) -> OAuthProvider {
    return OAuthProvider(providerID: providerID, auth: Auth.auth())
  }

  /**
      @param providerID The provider ID of the IDP for which this auth provider instance will be
          configured.
      @param auth The auth instance to be associated with the `OAuthProvider` instance.
      @return An instance of `OAuthProvider` corresponding to the specified provider ID.
   */
  @objc(providerWithProviderID:auth:) public class func provider(providerID: String,
                                                                 auth: Auth) -> OAuthProvider {
    return OAuthProvider(providerID: providerID, auth: auth)
  }

  /** @property scopes
      @brief Array used to configure the OAuth scopes.
   */
  @objc public let scopes: [String]

  /** @property customParameters
      @brief Dictionary used to configure the OAuth custom parameters.
   */
  @objc public let customParameters: [String: String]

  /** @property providerID
      @brief The provider ID indicating the specific OAuth provider this OAuthProvider instance
            represents.
   */
  @objc public let providerID: String

  /**
      @param providerID The provider ID of the IDP for which this auth provider instance will be
          configured.
      @return An instance of `OAuthProvider` corresponding to the specified provider ID.
   */
  @objc(providerWithProviderID:) public convenience init(providerID: String) {
    self.init(providerID: providerID, auth: Auth.auth())
  }

  /**
      @param providerID The provider ID of the IDP for which this auth provider instance will be
          configured.
      @param auth The auth instance to be associated with the `OAuthProvider` instance.
      @return An instance of `OAuthProvider` corresponding to the specified provider ID.
   */
  @objc(providerWithProviderID:auth:) public init(providerID: String, auth: Auth) {
    // TODO:
    self.auth = auth

    // if auth.app
    callbackScheme = "todo"
    usingClientIDScheme = false
    scopes = [""]
    customParameters = [:]
    self.providerID = OAuthProvider.id
  }

  /**
      @brief Creates an `AuthCredential` for the OAuth 2 provider identified by provider ID, ID
          token, and access token.

      @param providerID The provider ID associated with the Auth credential being created.
      @param idToken The IDToken associated with the Auth credential being created.
      @param accessToken The access token associated with the Auth credential be created, if
          available.
      @return A `AuthCredential` for the specified provider ID, ID token and access token.
   */
  @objc(credentialWithProviderID:IDToken:accessToken:)
  public static func credential(withProviderID providerID: String,
                                idToken: String,
                                accessToken: String?) -> OAuthCredential {
    return OAuthCredential(withProviderID: providerID, IDToken: idToken, accessToken: accessToken)
  }

  /**
      @brief Creates an `AuthCredential` for the OAuth 2 provider identified by provider ID using
        an ID token.

      @param providerID The provider ID associated with the Auth credential being created.
      @param accessToken The access token associated with the Auth credential be created
      @return An `AuthCredential`.
   */
  @objc(credentialWithProviderID:accessToken:)
  public static func credential(withProviderID providerID: String,
                                accessToken: String) -> OAuthCredential {
    return OAuthCredential(withProviderID: providerID, accessToken: accessToken)
  }

  /**
      @brief Creates an `AuthCredential` for that OAuth 2 provider identified by provider ID, ID
          token, raw nonce, and access token.

      @param providerID The provider ID associated with the Auth credential being created.
      @param idToken The IDToken associated with the Auth credential being created.
      @param rawNonce The raw nonce associated with the Auth credential being created.
      @param accessToken The access token associated with the Auth credential be created, if
          available.
      @return A `AuthCredential` for the specified provider ID, ID token and access token.
   */
  @objc(credentialWithProviderID:IDToken:rawNonce:accessToken:)
  public static func credential(withProviderID providerID: String, idToken: String,
                                rawNonce: String,
                                accessToken: String) -> OAuthCredential {
    return OAuthCredential(
      withProviderID: providerID,
      IDToken: idToken,
      rawNonce: rawNonce,
      accessToken: accessToken
    )
  }

  /**
      @brief Creates an `AuthCredential` for that OAuth 2 provider identified by providerID using
        an ID token and raw nonce.

      @param providerID The provider ID associated with the Auth credential being created.
      @param idToken The IDToken associated with the Auth credential being created.
      @param rawNonce The raw nonce associated with the Auth credential being created.
      @return A `AuthCredential`.
   */
  @objc(credentialWithProviderID:IDToken:rawNonce:)
  public static func credential(withProviderID providerID: String, idToken: String,
                                rawNonce: String) -> OAuthCredential {
    return OAuthCredential(withProviderID: providerID, IDToken: idToken, rawNonce: rawNonce)
  }

  #if os(iOS)
    @objc(getCredentialWithUIDelegate:completion:)
    public func getCredentialWith(_ UIDelegate: AuthUIDelegate?,
                                  completion: ((AuthCredential?, Error?) -> Void)? = nil) {
      // TODO:
    }

    @available(iOS 13, tvOS 13, macOS 10.15, watchOS 8, *)
    public func credential(with UIDelegate: AuthUIDelegate?) async throws -> AuthCredential {
      return try await withCheckedThrowingContinuation { continuation in
        getCredentialWith(UIDelegate) { credential, error in
          if let credential = credential {
            continuation.resume(returning: credential)
          } else {
            continuation.resume(throwing: error!) // TODO: Change to ?? and generate unknown error
          }
        }
      }
    }
  #endif

  private let auth: Auth
  private let callbackScheme: String
  private let usingClientIDScheme: Bool
}

@objc(FIROAuthCredential) public class OAuthCredential: AuthCredential { // }, NSSecureCoding {
  /** @property IDToken
      @brief The ID Token associated with this credential.
   */
  @objc public let IDToken: String?

  /** @property accessToken
      @brief The access token associated with this credential.
   */
  @objc public let accessToken: String?

  /** @property secret
      @brief The secret associated with this credential. This will be nil for OAuth 2.0 providers.
      @detail OAuthCredential already exposes a providerId getter. This will help the developer
          determine whether an access token/secret pair is needed.
   */
  @objc public let secret: String?

  // TODO: delete objc's and public's below
  // internal
  @objc public let OAuthResponseURLString: String?
  @objc public let sessionID: String?
  @objc public let pendingToken: String?
  // private
  @objc public let rawNonce: String?

  // TODO: Remove public objc
  @objc public init(withProviderID providerID: String,
                    IDToken: String? = nil,
                    rawNonce: String? = nil,
                    accessToken: String? = nil,
                    secret: String? = nil,
                    pendingToken: String? = nil) {
    self.IDToken = IDToken
    self.rawNonce = rawNonce
    self.accessToken = accessToken
    self.pendingToken = pendingToken
    self.secret = secret
    OAuthResponseURLString = nil
    sessionID = nil
    super.init(provider: providerID)
  }

  @objc public init(withProviderID providerID: String,
                    sessionID: String,
                    OAuthResponseURLString: String) {
    self.sessionID = sessionID
    self.OAuthResponseURLString = OAuthResponseURLString
    accessToken = nil
    pendingToken = nil
    secret = nil
    IDToken = nil
    rawNonce = nil
    super.init(provider: providerID)
  }

  @objc public convenience init(withVerifyAssertionResponse response: VerifyAssertionResponse) {
    self.init(withProviderID: response.providerID ?? OAuthProvider.id,
              IDToken: response.oauthIDToken,
              rawNonce: nil,
              accessToken: response.oauthAccessToken,
              secret: response.oauthSecretToken,
              pendingToken: response.pendingToken)
  }
//
//  public static var supportsSecureCoding = true
//
//  public func encode(with coder: NSCoder) {
//    coder.encode(verificationID)
//    coder.encode(verificationCode)
//    coder.encode(temporaryProof)
//    coder.encode(OAuthNumber)
//  }
//
//  required public init?(coder: NSCoder) {
//    let verificationID = coder.decodeObject(forKey: "verificationID") as? String
//    let verificationCode = coder.decodeObject(forKey: "verificationCode") as? String
//    let temporaryProof = coder.decodeObject(forKey: "temporaryProof") as? String
//    let OAuthNumber = coder.decodeObject(forKey: "OAuthNumber") as? String
//    if let temporaryProof = temporaryProof,
//       let OAuthNumber = OAuthNumber {
//      self.temporaryProof = temporaryProof
//      self.OAuthNumber = OAuthNumber
//      self.verificationID = nil
//      self.verificationCode = nil
//      super.init(provider: OAuthProvider.id)
//    } else if let verificationID = verificationID,
//              let verificationCode = verificationCode {
//      self.verificationID = verificationID
//      self.verificationCode = verificationCode
//      self.temporaryProof = nil
//      self.OAuthNumber = nil
//      super.init(provider: OAuthProvider.id)
//    } else {
//      return nil
//    }
//  }
}