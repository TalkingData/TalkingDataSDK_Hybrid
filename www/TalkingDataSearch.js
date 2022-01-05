var TalkingDataSearch = {
    /**
     * 创建搜索详情
     */
    createSearch: function() {
        var search = {};
        /**
         * 设置搜索分类
         * @param {string}  category        : 搜索分类
         */
        search.setCategory = function(category) {
            search.category = category;
        };
        /**
         * 设置搜索内容
         * @param {string}  content         : 搜索内容
         */
        search.setContent = function(content) {
            search.content = content;
        };
        /**
         * （电商零售专用）设置商品ID
         * @param {string}  itemId          : 商品ID
         */
        search.setItemId = function(itemId) {
            search.itemId = itemId;
        };
        /**
         * （电商零售专用）设置商品位置
         * @param {string}  itemLocationId  : 商品位置
         */
        search.setItemLocationId = function(itemLocationId) {
            search.itemLocationId = itemLocationId;
        };
        /**
         * （旅游出行专用）设置目的地城市
         * @param {string}  destination     : 目的地城市
         */
        search.setDestination = function(destination) {
            search.destination = destination;
        };
        /**
         * （旅游出行专用）设置出发地城市
         * @param {string}  origin          : 出发地城市
         */
        search.setOrigin = function(origin) {
            search.origin = origin;
        };
        /**
         * （旅游出行专用）设置起始时间
         * @param {number}  startDate       : 起始时间
         */
        search.setStartDate = function(startDate) {
            search.startDate = startDate;
        };
        /**
         * （旅游出行专用）设置截止时间
         * @param {number}  endDate         : 截止时间
         */
        search.setEndDate = function(endDate) {
            search.endDate = endDate;
        };
        return search;
    }
};
