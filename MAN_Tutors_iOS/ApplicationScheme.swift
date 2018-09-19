/*
Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import UIKit

import MaterialComponents

class ApplicationScheme: NSObject {
	
	private static var singleton = ApplicationScheme()
	
	static var shared: ApplicationScheme {
		return singleton
	}
	
	override init() {
		self.buttonScheme.colorScheme = self.colorScheme
		
		super.init()
	}
	
	public let buttonScheme = MDCButtonScheme()
	public let textFieldScheme = MDCSemanticColorScheme()
	
	
	public let colorScheme: MDCColorScheming = {
		let scheme = MDCSemanticColorScheme(defaults: .material201804)
		scheme.primaryColor = UIColor(red: 1.00, green: 0.92, blue: 0.23, alpha: 1.0);
		scheme.primaryColorVariant = UIColor(red: 0.78, green: 0.73, blue: 0.00, alpha: 1.0);
		scheme.onPrimaryColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.0);
		scheme.secondaryColor = UIColor(red: 0.33, green: 0.43, blue: 0.48, alpha: 1.0);
		scheme.surfaceColor = UIColor(red: 0.51, green: 0.61, blue: 0.66, alpha: 1.0);
		scheme.onSurfaceColor = scheme.primaryColorVariant
		scheme.onSecondaryColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0);
		scheme.backgroundColor = UIColor(red: 0.33, green: 0.43, blue: 0.48, alpha: 1.0);
		scheme.onBackgroundColor = scheme.primaryColorVariant
		scheme.errorColor =
			UIColor(red: 1.00, green: 0.05, blue: 0.05, alpha: 1.0)
		return scheme
	}()
	
//	public let typographyScheme: MDCTypographyScheming = {
//		let scheme = MDCTypographyScheme()
//		let fontName = "Rubik"
//		scheme.headline5 = UIFont(name: fontName, size: 24)!
//		scheme.headline6 = UIFont(name: fontName, size: 20)!
//		scheme.subtitle1 = UIFont(name: fontName, size: 16)!
//		scheme.button = UIFont(name: fontName, size: 14)!
//		return scheme
//	}()
}
