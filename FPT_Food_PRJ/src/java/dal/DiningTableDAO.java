/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DiningTable;

/**
 *
 * @author AN
 */
public class DiningTableDAO extends DBContext {

    public Map<? extends DiningTable, ? extends Double> getDiningTableAndFinalPrice() {
        Map<DiningTable, Double> listBills = new HashMap<>();
        connection = getConnection();
        String sql = "SELECT \n"
                + "    d.tableID,\n"
                + "    d.tableName,\n"
                + "    d.seatCount,\n"
                + "    d.status,\n"
                + "    o.finalPrice\n"
                + "FROM \n"
                + "    DiningTable d\n"
                + "JOIN \n"
                + "    Orders o ON d.tableID = o.tableID\n"
                + "WHERE \n"
                + "    d.status = 'busy';";
        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int tableID = resultSet.getInt("tableID");
                String tableName = resultSet.getString("tableName");
                int seatCount = resultSet.getInt("seatCount");
                String status = resultSet.getString("status");
                Double finalPrice = resultSet.getDouble("finalPrice");
                DiningTable d = DiningTable.builder()
                        .tableID(tableID)
                        .tableName(tableName)
                        .seatCount(seatCount)
                        .status(status).build();
                listBills.put(d, finalPrice);
            }
        } catch (SQLException ex) {
            System.out.println(ex.toString());
        }
        return listBills;
    }

    public int updateStatusTable(int tableId) {
        int resultSet = 0;
        connection = getConnection();
        String sql = "UPDATE [dbo].[DiningTable]\n"
                + "   SET \n"
                + "      [status] = ?\n"
                + " WHERE tableID = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, "empty");
            statement.setInt(2, tableId);
            resultSet = statement.executeUpdate();
        } catch (SQLException ex) {
            System.out.println(ex.toString());
        }
        return resultSet;
    }

}
