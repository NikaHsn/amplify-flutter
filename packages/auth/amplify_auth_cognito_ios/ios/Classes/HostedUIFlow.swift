// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
import AuthenticationServices
import Combine
import SafariServices

/// Manages the sign in/sign out process using `ASWebAuthenticationSession`.
class HostedUIFlow: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    /// Launches `url` in an `ASWebAuthenticationSession`.
    ///
    /// `url` is either the signin or signout URL.
    public func launchUrl(
        _ url: String,
        callbackURLScheme: String,
        preferPrivateSession: Bool,
        callback: @escaping (Result<[String: String], HostedUIError>) -> ()
    ) {
        guard let uri = URL(string: url) else {
            callback(.failure(HostedUIError.unknown("Invalid URL: \(url)")))
            return
        }
        let session = ASWebAuthenticationSession(url: uri, callbackURLScheme: callbackURLScheme) {
            callbackURL, error in
            if let error = error {
                callback(.failure(HostedUIError.fromError(error)))
                return
            }
            guard let callbackURL = callbackURL else {
                callback(.failure(HostedUIError.unknown("Nil callback URL")))
                return
            }
            let queryParameters = HostedUIFlow.processParameters(callbackURL)
            callback(.success(queryParameters))
        }

        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = preferPrivateSession
        DispatchQueue.main.async {
            guard session.start() else {
                callback(.failure(HostedUIError.unknown("Could not start ASWebAuthenticationSession")))
                return
            }
        }
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }

    /// Collects the query parameters returned in `callbackURL`.
    static private func processParameters(_ callbackURL: URL) -> [String: String] {
        let urlComponents = URLComponents(string: callbackURL.absoluteString)
        guard let queryItems = urlComponents?.queryItems else {
            return [:]
        }
        var queryParameters: [String: String] = [:]
        for queryItem in queryItems {
            queryParameters[queryItem.name] = queryItem.value ?? ""
        }
        return queryParameters
    }
    
}