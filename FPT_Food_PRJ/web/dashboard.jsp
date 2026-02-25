<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.DecimalFormat" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // --- PHẦN 1: GIẢ LẬP DỮ LIỆU (MOCK DATA) ---
    DecimalFormat formatter = new DecimalFormat("#,###");

    // --- [MỚI] XỬ LÝ LOGIC TAB ĐƯỢC CHỌN ---
    // Lấy tham số "tab" từ URL request. Nếu không có thì mặc định là "tables"
    String activeTab = request.getAttribute("activeTab") + "";
    if (activeTab.equalsIgnoreCase("null") || activeTab.isEmpty()) {
        activeTab = "tables";
    }
    // ... (Giữ nguyên phần Mock Data bàn, món ăn, v.v... của bạn) ...
    // 1. Danh sách Bàn
    List<Map<String, Object>> tableList = new ArrayList<>();
    for (int i = 1; i <= 6; i++) {
        Map<String, Object> t = new HashMap<>();
        t.put("id", i);
        t.put("name", "Bàn " + i);
        if (i == 2) {
            t.put("status", "busy");
            t.put("itemCount", 1);
            t.put("total", 300000);
        } else if (i == 5) {
            t.put("status", "busy");
            t.put("itemCount", 3);
            t.put("total", 150000);
        } else if (i == 3) {
            t.put("status", "busy");
            t.put("itemCount", 0);
            t.put("total", 0);
        } else {
            t.put("status", "empty");
            t.put("itemCount", 0);
            t.put("total", 0);
        }
        tableList.add(t);
    }

    // 2. Danh sách Danh mục
    List<Map<String, Object>> categoryList = new ArrayList<>();
    categoryList.add(new HashMap<String, Object>() {
        {
            put("id", 1);
            put("name", "Pizza");
            put("desc", "Các loại bánh Pizza Ý");
        }
    });
    categoryList.add(new HashMap<String, Object>() {
        {
            put("id", 2);
            put("name", "Đồ uống");
            put("desc", "Nước ngọt, Trà, Cà phê");
        }
    });
    categoryList.add(new HashMap<String, Object>() {
        {
            put("id", 3);
            put("name", "Món chính");
            put("desc", "Cơm, Mì, Beefsteak");
        }
    });

    // 3. Danh sách Món ăn
    List<Map<String, Object>> foodList = new ArrayList<>();
    foodList.add(new HashMap<String, Object>() {
        {
            put("id", 1);
            put("name", "Pizza Hải Sản");
            put("price", 150000);
            put("cat", "Pizza");
        }
    });
    foodList.add(new HashMap<String, Object>() {
        {
            put("id", 2);
            put("name", "Burger Bò");
            put("price", 80000);
            put("cat", "Món chính");
        }
    });

    // 4. Danh sách Kho
    List<Map<String, Object>> inventoryList = new ArrayList<>();
    inventoryList.add(new HashMap<String, Object>() {
        {
            put("id", 1);
            put("name", "Bột mì");
            put("unit", "kg");
            put("qty", 50);
        }
    });

    // 5. Danh sách Tài khoản
    List<Map<String, Object>> userList = new ArrayList<>();
    userList.add(new HashMap<String, Object>() {
        {
            put("id", 1);
            put("username", "admin");
            put("role", "admin");
        }
    });
    userList.add(new HashMap<String, Object>() {
        {
            put("id", 2);
            put("username", "nhanvien1");
            put("role", "worker");
        }
    });
    userList.add(new HashMap<String, Object>() {
        {
            put("id", 3);
            put("username", "nhanvien2");
            put("role", "worker");
        }
    });
%>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="login.jsp"></c:redirect> 
</c:if>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>FPT Food - Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="./css/dashboard.css"/>
        <style>
            .tab-btn {
                text-decoration: none; /* Xóa gạch chân mặc định của thẻ a */
                display: flex;         /* Sử dụng Flexbox để dàn trang */
                justify-content: center; /* Canh giữa theo chiều ngang */
                align-items: center;     /* Canh giữa theo chiều dọc */
                gap: 10px;             /* Tạo khoảng cách giữa icon và chữ */
                color: #333;           /* Đặt màu chữ (để không bị màu xanh mặc định link) */
                cursor: pointer;

                /* Giữ lại các style cũ của button (nếu cần thiết lập lại) */
                padding: 10px 20px;
                border: 1px solid #ddd;
                border-bottom: none;
                background-color: #f8f9fa;
                font-weight: bold;
            }

            /* Khi tab đang active */
            .tab-btn.active {
                background-color: #fff;
                color: #007bff; /* Màu chữ khi được chọn */
                border-top: 3px solid #007bff;
            }

            /* Hiệu ứng khi di chuột vào */
            .tab-btn:hover {
                background-color: #e9ecef;
                color: #0056b3;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="brand">
                <h1>FPT Food - Dashboard</h1>
                <p>Xin chào, Quản lý</p>
            </div>
            <a href="logoutController" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        </header>

        <div class="container">
            <div class="nav-tabs">
                <a href="?tab=tables" class="tab-btn <%= activeTab.equals("tables") ? "active" : ""%>"><i class="fas fa-chair"></i> Quản lý bàn</a>
                <a href="?tab=categories" class="tab-btn <%= activeTab.equals("categories") ? "active" : ""%>"><i class="fas fa-tags"></i> Danh mục</a>
                <a href="?tab=food" class="tab-btn <%= activeTab.equals("food") ? "active" : ""%>"><i class="fas fa-utensils"></i> Món ăn</a>
                <a href="ingredientController?from=dashboard" class="tab-btn ${activeTab == 'inventory' ? 'active' : ''}"><i class="fas fa-boxes"></i> Quản lý kho</a>
                <a href="UserController" class="tab-btn ${activeTab == 'accounts' ? 'active' : ''}"><i class="fas fa-users"></i> Tài khoản</a> 
                <a href="diningTableController?action=bills" class="tab-btn ${activeTab == 'bills' ? 'active' : ''}"><i class="fas fa-file-invoice-dollar"></i> Hóa đơn</a>
            </div>

            <section id="tables" class="section-content <%= activeTab.equals("tables") ? "active" : ""%>">
                <div class="table-grid">
                    <% for (Map<String, Object> t : tableList) {
                            String status = (String) t.get("status");
                            String statusText = status.equals("empty") ? "Trống" : (status.equals("busy") ? "Đang dùng" : "Đã đặt");
                            int itemCount = (int) t.get("itemCount");
                            int total = (int) t.get("total");
                            String formattedTotal = formatter.format(total);
                    %>
                    <div class="table-card">
                        <div class="table-header">
                            <b><%= t.get("name")%></b>
                            <span class="badge <%= status%>"><%= statusText%></span>
                        </div>
                        <form action="UpdateTableServlet" method="POST">
                            <input type="hidden" name="tableId" value="<%= t.get("id")%>">
                            <input type="hidden" name="currentTab" value="tables">
                            <div class="status-control">
                                <select name="status" class="status-select">
                                    <option value="empty" <%= status.equals("empty") ? "selected" : ""%>>Trống</option>
                                    <option value="busy" <%= status.equals("busy") ? "selected" : ""%>>Đang dùng</option>
                                    <option value="booked" <%= status.equals("booked") ? "selected" : ""%>>Đã đặt</option>
                                </select>
                                <button type="submit" class="btn-save" title="Lưu lại"><i class="fas fa-save"></i></button>
                            </div>
                        </form>
                        <% if (status.equals("busy")) {%>
                        <div class="order-summary">
                            Đang phục vụ: <%= itemCount%> món
                            <span class="total-price">Tổng: <%= formattedTotal%>đ</span>
                        </div>
                        <% } %>
                    </div>
                    <% }%>
                </div>
            </section>

            <section id="categories" class="section-content <%= activeTab.equals("categories") ? "active" : ""%>">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h3>Danh mục món ăn</h3>
                    <button class="btn-add" onclick="openAddCategoryModal()">+ Thêm danh mục</button>
                </div>
                <table class="data-table">
                    <thead><tr><th>ID</th><th>Tên danh mục</th><th>Mô tả</th><th>Thao tác</th></tr></thead>
                    <tbody>
                        <% for (Map<String, Object> c : categoryList) {%>
                        <tr>
                            <td><%= c.get("id")%></td><td><b><%= c.get("name")%></b></td><td><%= c.get("desc")%></td>
                            <td>
                                <button class="action-btn" style="color:blue" onclick="openEditCategoryModal('<%= c.get("id")%>', '<%= c.get("name")%>', '<%= c.get("desc")%>')"><i class="fas fa-edit"></i></button>
                                <form action="DeleteCategoryServlet" method="POST" style="display:inline;" onsubmit="return confirm('Xóa?')">
                                    <input type="hidden" name="id" value="<%= c.get("id")%>">
                                    <input type="hidden" name="currentTab" value="categories"> <button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </section>

            <section id="food" class="section-content <%= activeTab.equals("food") ? "active" : ""%>">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h3>Danh sách món ăn</h3>
                    <button class="btn-add" onclick="openAddFoodModal()">+ Thêm món</button>
                </div>
                <table class="data-table">
                    <thead><tr><th>Tên món</th><th>Danh mục</th><th>Giá</th><th>Thao tác</th></tr></thead>
                    <tbody>
                        <% for (Map<String, Object> f : foodList) {%>
                        <tr>
                            <td><%= f.get("name")%></td><td><%= f.get("cat")%></td><td><%= f.get("price")%>đ</td>
                            <td>
                                <button class="action-btn" style="color:blue" onclick="openEditFoodModal('<%= f.get("id")%>', '<%= f.get("name")%>', '<%= f.get("price")%>')"><i class="fas fa-edit"></i></button>
                                <form action="DeleteFoodServlet" method="POST" style="display:inline;" onsubmit="return confirm('Xóa?')">
                                    <input type="hidden" name="id" value="<%= f.get("id")%>">
                                    <input type="hidden" name="currentTab" value="food"> <button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </section>

            <section id="inventory" class="section-content ${activeTab == 'inventory' ? 'active' : ''}">
                <div style="display:flex; justify-content:space-between;">
                    <h3>Kho nguyên liệu</h3>
                    <button class="btn-add" style="background:#28a745" onclick="document.getElementById('inventoryModal').classList.add('active')">+ Nhập kho</button>
                </div>
                <table class="data-table">
                    <thead><tr><th>Tên</th><th>Đơn vị</th><th>Số lượng</th><th>Thao tác</th></tr></thead>
                    <tbody>
                        <c:forEach items="${requestScope.listIngredient}" var="i">
                            <tr>
                                <td>${i.name}</td><td>${i.unit}</td><td>${i.quantityInStock}</td>
                                <td>
                                    <form action="ingredientController?action=delete&&from=dashboard" method="POST" style="display:inline;" onsubmit="return confirm('Xóa?')">
                                        <input type="hidden" name="id" value="${i.ingredientID}">
                                        <input type="hidden" name="currentTab" value="inventory"> <button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <section id="accounts" class="section-content <c:if test="${requestScope.activeTab == 'accounts'}">active</c:if>">
                    <div style="display:flex; justify-content:space-between;">
                        <h3>Danh sách tài khoản</h3>
                        <button class="btn-add" onclick="openAddAccountModal()">+ Tạo tài khoản</button>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr><th>ID</th><th>Tên đăng nhập</th><th>Vai trò (Role)</th><th>Thao tác</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${requestScope.listUser}" var="u">
                            <tr>
                                <td>${u.userID}</td>
                                <td><b>${u.username}</b></td>
                                <td><span>${u.role}</span></td>
                                <td>
                                    <form action="UserController?action=delete" method="POST" style="display:inline;" onsubmit="return confirm('Xóa tài khoản này?')">
                                        <input type="hidden" name="id" value="${u.userID}">
                                        <input type="hidden" name="currentTab" value="accounts"> <button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <section id="bills" class="section-content ${activeTab == 'bills' ? 'active' : ''}">
                <h3>Hóa đơn cần thanh toán</h3>
                <div class="table-grid">
                    <c:forEach items="${listBills}" var="b">
                        <c:if test="${b.key.status == 'busy'}">
                            <div class="table-card" style="border-left: 5px solid var(--danger);">
                                <div style="display:flex; justify-content:space-between; margin-bottom:10px;"><b>${b.key.tableName}</b><span class="badge busy">Chưa thanh toán</span></div>
                                <p>Tổng tiền tạm tính: <b>${b.value}đ</b></p>
                                <form action="diningTableController?action=pay" method="POST" style="margin-top:15px;">
                                    <input type="hidden" name="tableId" value="${b.key.tableID}">
                                    <input type="hidden" name="currentTab" value="bills"> <button type="submit" class="btn-add" style="width:100%; background:#28a745;">Xác nhận Thanh toán</button>
                                </form>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </section>
        </div>

        <div class="modal" id="accountModal">
            <div class="modal-content">
                <h3>Tạo tài khoản mới</h3>
                <form action="UserController?action=add" method="POST">
                    <input type="hidden" name="currentTab" value="accounts"> <label>Tên đăng nhập:</label>
                    <input type="text" name="username" id="accUsername" class="form-control" required>
                    <label>Mật khẩu:</label>
                    <input type="text" name="password" id="accPassword" class="form-control" required>
                    <label>Vai trò:</label>
                    <select name="role" id="accRole" class="form-control">
                        <option value="worker">Worker (Nhân viên)</option>
                        <option value="manager">Admin (Quản lý)</option>
                    </select>
                    <div class="modal-footer">
                        <button type="button" class="action-btn" onclick="document.getElementById('accountModal').classList.remove('active')">Hủy</button>
                        <button type="submit" class="btn-add">Tạo mới</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal" id="categoryModal">
            <div class="modal-content">
                <h3>Thông tin danh mục</h3>
                <form action="SaveCategoryServlet" method="POST">
                    <input type="hidden" name="currentTab" value="categories"> <input type="hidden" name="id" id="modalCatId">
                    <label>Tên danh mục:</label><input type="text" name="name" id="modalCatName" class="form-control" required>
                    <label>Mô tả:</label><input type="text" name="desc" id="modalCatDesc" class="form-control">
                    <div class="modal-footer"><button type="button" class="action-btn" onclick="document.getElementById('categoryModal').classList.remove('active')">Hủy</button><button type="submit" class="btn-add">Lưu lại</button></div>
                </form>
            </div>
        </div>

        <div class="modal" id="foodModal">
            <div class="modal-content">
                <h3>Thông tin món ăn</h3>
                <form action="SaveFoodServlet" method="POST">
                    <input type="hidden" name="currentTab" value="food"> <input type="hidden" name="id" id="modalFoodId">
                    <label>Tên món:</label><input type="text" name="name" id="modalFoodName" class="form-control" required>
                    <label>Giá bán:</label><input type="number" name="price" id="modalFoodPrice" class="form-control" required>
                    <div class="modal-footer"><button type="button" class="action-btn" onclick="document.getElementById('foodModal').classList.remove('active')">Hủy</button><button type="submit" class="btn-add">Lưu lại</button></div>
                </form>
            </div>
        </div>

        <div class="modal" id="inventoryModal">
            <div class="modal-content">
                <h3>Nhập kho mới</h3>
                <form action="ingredientController?action=add&from=dashboard" method="POST">
                    <input type="hidden" name="currentTab" value="inventory"> <label>Tên nguyên liệu:</label><input type="text" name="name" class="form-control" required>
                    <label>Số lượng:</label><input type="number" name="qty" class="form-control" required>
                    <div class="modal-footer"><button type="button" class="action-btn" onclick="document.getElementById('inventoryModal').classList.remove('active')">Hủy</button><button type="submit" class="btn-add">Lưu</button></div>
                </form>
            </div>
        </div>

        <script>
            // Hàm switchTab đã bị loại bỏ vì bây giờ chúng ta dùng thẻ <a> href="?tab=..." 
            // để gửi request lên server (reload trang) theo đúng yêu cầu của bạn.

            // JS cho Tài khoản
            function openAddAccountModal() {
                document.getElementById('accUsername').value = "";
                document.getElementById('accPassword').value = "";
                document.getElementById('accRole').value = "worker"; // Default
                document.getElementById('accountModal').classList.add('active');
            }

            // Các hàm cũ giữ nguyên
            function openAddCategoryModal() {
                document.getElementById('modalCatId').value = "";
                document.getElementById('modalCatName').value = "";
                document.getElementById('modalCatDesc').value = "";
                document.getElementById('categoryModal').classList.add('active');
            }
            function openEditCategoryModal(id, name, desc) {
                document.getElementById('modalCatId').value = id;
                document.getElementById('modalCatName').value = name;
                document.getElementById('modalCatDesc').value = desc;
                document.getElementById('categoryModal').classList.add('active');
            }
            function openAddFoodModal() {
                document.getElementById('modalFoodId').value = "";
                document.getElementById('modalFoodName').value = "";
                document.getElementById('modalFoodPrice').value = "";
                document.getElementById('foodModal').classList.add('active');
            }
            function openEditFoodModal(id, name, price) {
                document.getElementById('modalFoodId').value = id;
                document.getElementById('modalFoodName').value = name;
                document.getElementById('modalFoodPrice').value = price;
                document.getElementById('foodModal').classList.add('active');
            }
        </script>
    </body>
</html>