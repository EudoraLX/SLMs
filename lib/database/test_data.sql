USE server_parts_management;

-- 插入配件类型
INSERT INTO part_types (name, description) VALUES
('CPU', '中央处理器'),
('内存', '随机存取存储器'),
('存储', '硬盘和固态硬盘'),
('电源', '服务器电源'),
('主板', '服务器主板'),
('网卡', '网络接口卡'),
('显卡', '图形处理器'),
('散热器', 'CPU散热器'),
('机箱', '服务器机箱');

-- 插入制造商
INSERT INTO manufacturers (name, website, contact_info) VALUES
('Intel', 'https://www.intel.com', 'sales@intel.com'),
('AMD', 'https://www.amd.com', 'sales@amd.com'),
('Samsung', 'https://www.samsung.com', 'sales@samsung.com'),
('Dell', 'https://www.dell.com', 'sales@dell.com'),
('HPE', 'https://www.hpe.com', 'sales@hpe.com'),
('Lenovo', 'https://www.lenovo.com', 'sales@lenovo.com'),
('Cisco', 'https://www.cisco.com', 'sales@cisco.com'),
('NVIDIA', 'https://www.nvidia.com', 'sales@nvidia.com');

-- 插入位置
INSERT INTO locations (name, address, capacity) VALUES
('仓库A', '北京市海淀区中关村大街1号', 1000),
('仓库B', '上海市浦东新区张江高科技园区', 800),
('仓库C', '广州市天河区珠江新城', 600),
('维修区', '深圳市南山区科技园', 200),
('展示区', '杭州市西湖区文三路', 100);

-- 插入供应商
INSERT INTO suppliers (name, contact_person, phone, email, address) VALUES
('Intel官方', '张三', '13800138000', 'zhangsan@intel.com', '北京市海淀区中关村'),
('AMD官方', '李四', '13900139000', 'lisi@amd.com', '上海市浦东新区'),
('Samsung官方', '王五', '13700137000', 'wangwu@samsung.com', '广州市天河区'),
('Dell官方', '赵六', '13600136000', 'zhaoliu@dell.com', '深圳市南山区'),
('HPE官方', '钱七', '13500135000', 'qianqi@hpe.com', '杭州市西湖区'),
('Lenovo官方', '孙八', '13400134000', 'sunba@lenovo.com', '南京市鼓楼区');

-- 插入保修期
INSERT INTO warranty_periods (name, months, description) VALUES
('1年', 12, '标准一年保修'),
('2年', 24, '延长两年保修'),
('3年', 36, '三年保修服务'),
('5年', 60, '五年保修服务'),
('终身', 999, '终身保修服务');

-- 插入状态类型
INSERT INTO status_types (name, description) VALUES
('In Stock', '库存中'),
('In Use', '使用中'),
('Sold', '已售出'),
('Repair', '维修中'),
('Scrapped', '已报废');

-- 插入支付方式
INSERT INTO payment_methods (name, description) VALUES
('现金', '现金支付'),
('银行转账', '银行转账支付'),
('支付宝', '支付宝支付'),
('微信支付', '微信支付'),
('信用卡', '信用卡支付');

-- 插入操作类型
INSERT INTO operation_types (name, description) VALUES
('入库', '物品入库操作'),
('出库', '物品出库操作'),
('维修', '物品维修操作'),
('报废', '物品报废操作'),
('转移', '物品位置转移操作');

-- 插入测试配件（多类型、多状态）
INSERT INTO parts (serial_number, type_id, model, manufacturer_id, specifications, purchase_cost, selling_price, quantity, location_id, supplier_id, warranty_id, status_id, purchase_date) VALUES
('CPU001', 1, 'Intel Xeon Gold 6248R', 1, '24核心48线程，3.0GHz', 5000.00, 6000.00, 10, 1, 1, 1, 1, '2024-01-01'),
('CPU002', 1, 'AMD EPYC 7742', 2, '64核心128线程，2.25GHz', 6000.00, 7200.00, 8, 2, 2, 2, 2, '2024-01-02'),
('RAM001', 2, 'DDR4-3200 32GB', 3, '32GB ECC内存', 800.00, 1000.00, 20, 3, 3, 1, 1, '2024-01-03'),
('SSD001', 3, '1.92TB SSD', 3, '1.92TB企业级SSD', 2000.00, 2500.00, 15, 4, 3, 2, 3, '2024-01-04'),
('PSU001', 4, '1600W Platinum', 4, '1600W铂金电源', 1500.00, 1800.00, 12, 5, 4, 1, 4, '2024-01-05'),
('MB001', 5, 'SuperMicro X11', 5, '双路主板', 1200.00, 1500.00, 5, 1, 5, 2, 1, '2024-01-06'),
('NIC001', 6, 'Intel X550-T2', 1, '10GbE双口网卡', 900.00, 1200.00, 7, 2, 1, 1, 2, '2024-01-07'),
('GPU001', 7, 'NVIDIA RTX A6000', 8, '48GB显存', 20000.00, 25000.00, 2, 3, 6, 3, 1, '2024-01-08'),
('FAN001', 8, 'Noctua NH-U14S', 7, '高效静音风扇', 300.00, 400.00, 30, 4, 2, 1, 1, '2024-01-09'),
('CASE001', 9, '机箱A', 4, '4U机箱', 1000.00, 1200.00, 3, 5, 4, 2, 5, '2024-01-10');

-- 插入测试服务器（多制造商、多状态）
INSERT INTO servers (serial_number, model, manufacturer_id, specifications, purchase_cost, selling_price, quantity, location_id, supplier_id, warranty_id, status_id, assembly_date) VALUES
('SRV001', 'Dell PowerEdge R740', 4, '2U机架式服务器', 30000.00, 36000.00, 5, 1, 4, 2, 1, '2024-01-01'),
('SRV002', 'HPE ProLiant DL380', 5, '2U机架式服务器', 32000.00, 38400.00, 4, 2, 5, 2, 2, '2024-01-02'),
('SRV003', 'Lenovo ThinkSystem SR650', 6, '2U机架式服务器', 28000.00, 33600.00, 6, 3, 6, 1, 3, '2024-01-03'),
('SRV004', 'Dell PowerEdge R640', 4, '1U机架式服务器', 25000.00, 30000.00, 2, 4, 4, 1, 4, '2024-01-04'),
('SRV005', 'HPE ProLiant DL360', 5, '1U机架式服务器', 26000.00, 31000.00, 3, 5, 5, 2, 5, '2024-01-05');

-- 插入测试销售记录（多配件、多服务器）
INSERT INTO sales (item_type, serial_number, customer, quantity, unit_price, total_amount, sale_date, payment_method_id, notes) VALUES
('part', 'CPU001', '公司A', 2, 6000.00, 12000.00, '2024-01-10', 1, '正常销售'),
('part', 'RAM001', '公司B', 5, 1000.00, 5000.00, '2024-01-11', 2, '促销'),
('part', 'SSD001', '公司C', 3, 2500.00, 7500.00, '2024-01-12', 3, '大客户'),
('server', 'SRV001', '公司D', 1, 36000.00, 36000.00, '2024-01-13', 4, '服务器销售'),
('server', 'SRV003', '公司E', 2, 33600.00, 67200.00, '2024-01-14', 5, '批量采购');

-- 插入测试操作日志
INSERT INTO operation_logs (operation_type_id, item_type, serial_number, operator, details) VALUES
(1, 'server', 'SRV001', '管理员', '服务器入库'),
(1, 'part', 'CPU001', '管理员', 'CPU入库'),
(2, 'part', 'CPU001', '销售员', 'CPU出库销售'),
(2, 'server', 'SRV001', '销售员', '服务器出库销售'),
(1, 'part', 'RAM001', '管理员', '内存入库'),
(2, 'part', 'RAM001', '销售员', '内存出库销售'),
(1, 'part', 'SSD001', '管理员', 'SSD入库'),
(2, 'part', 'SSD001', '销售员', 'SSD出库销售'),
(1, 'server', 'SRV003', '管理员', '服务器入库'),
(2, 'server', 'SRV003', '销售员', '服务器出库销售'); 