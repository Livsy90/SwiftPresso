extension SwiftPresso {
    
    public enum Mapper {
        
        ///  HTML mapper to transform HTML text into NSAttributedString.
        /// - Returns: An HTML mapper value.
        public func htmlMapper() -> HTMLMapperProtocol {
            HTMLMapper()
        }
        
    }
    
}