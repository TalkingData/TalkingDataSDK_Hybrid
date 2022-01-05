var TalkingDataTransaction = {
    /**
     * 创建交易详情
     */
    createTransaction: function() {
        var transaction = {};
        /**
         * 设置交易ID
         * @param {string}  transactionId   : 交易ID
         */
        transaction.setTransactionId = function(transactionId) {
            transaction.transactionId = transactionId;
        };
        /**
         * 设置交易分类
         * @param {string}  category        : 交易分类
         */
        transaction.setCategory = function(category) {
            transaction.category = category;
        };
        /**
         * 设置交易额
         * @param {number}  amount          : 交易额
         */
        transaction.setAmount = function(amount) {
            transaction.amount = amount;
        };
        /**
         * 设置交易甲方
         * @param {string}  personA         : 交易甲方
         */
        transaction.setPersonA = function(personA) {
            transaction.personA = personA;
        };
        /**
         * 设置交易乙方
         * @param {string}  personB         : 交易乙方
         */
        transaction.setPersonB = function(personB) {
            transaction.personB = personB;
        };
        /**
         * 设置起始时间
         * @param {number}  startDate       : 起始时间
         */
        transaction.setStartDate = function(startDate) {
            transaction.startDate = startDate;
        };
        /**
         * 设置截止时间
         * @param {number}  endDate         : 截止时间
         */
        transaction.setEndDate = function(endDate) {
            transaction.endDate = endDate;
        };
        /**
         * 设置交易内容
         * @param {string}  content         : 交易内容
         */
        transaction.setContent = function(content) {
            transaction.content = content;
        };
        /**
         * 设置货币类型
         * @param {string}  currencyType    : 货币类型
         */
        transaction.setCurrencyType = function(currencyType) {
            transaction.currencyType = currencyType;
        };
        return transaction;
    }
};
