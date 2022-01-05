var TalkingDataOrder = {
    /**
     * 创建订单
     * @param {string}  orderId         : 订单ID
     * @param {number}  total           : 订单金额
     * @param {string}  currencyType    : 货币类型
     */
    createOrder: function(orderId, total, currencyType) {
        var order = {};
        order.orderId = orderId;
        order.total = total;
        order.currencyType = currencyType;
        order.items = [];
        /**
         * 添加订单详情
         * @param {string}  itemId      : 商品ID
         * @param {string}  category    : 商品类别
         * @param {string}  name        : 商品名称
         * @param {number}  unitPrice   : 商品单价
         * @param {number}  amount      : 商品数量
         */
        order.addItem = function(itemId, category, name, unitPrice, amount) {
            var item = {
                itemId: itemId,
                category: category,
                name: name,
                unitPrice: unitPrice,
                amount: amount
            };
            order.items.push(item);
        };
        return order;
    }
};
