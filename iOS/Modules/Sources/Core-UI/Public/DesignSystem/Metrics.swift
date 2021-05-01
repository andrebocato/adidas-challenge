import UIKit

/// Design system constants.
public enum DS {}
extension DS {
    public enum Spacing {
        /// CGFloat = 0
        public static let none: CGFloat = 0
        /// CGFloat = 2
        public static let micro: CGFloat = 2
        /// CGFloat = 4
        public static let tiny: CGFloat = 4
        /// CGFloat = 8
        public static let xxSmall: CGFloat = 8
        /// CGFloat = 12
        public static let xSmall: CGFloat = 12
        /// CGFloat = 16
        public static let small: CGFloat = 16
        /// CGFloat = 24
        public static let base: CGFloat = 24
        /// CGFloat = 32
        public static let medium: CGFloat = 32
        /// CGFloat = 48
        public static let large: CGFloat = 48
        /// CGFloat = 64
        public static let xLarge: CGFloat = 64
    }
}

extension DS {
    public enum LayoutSize {
        /// CGSize = (1, 1)
        public static let nano: CGSize = .init(width: 1, height: 1)
        /// CGSize = (16, 16)
        public static let small: CGSize = .init(width: 16, height: 16)
        /// CGSize = (32, 32)
        public static let medium: CGSize = .init(width: 32, height: 32)
        /// CGSize =  (48, 48)
        public static let large: CGSize = .init(width: 48, height: 48)
        /// CGSize =  (64, 64)
        public static let xLarge: CGSize = .init(width: 64, height: 64)
        /// CGSize =  (80, 80)
        public static let xxLarge: CGSize = .init(width: 80, height: 80)
    }
}

extension DS {
    public enum CornerRadius {
        /// CGFloat = 8
        public static let xxSmall: CGFloat = 8
    }
}

extension DS {
    public enum Component {
        /// CGFloat = 44
        public static let buttonSize: CGSize = .init(width: 44, height: 44)
    }
}
