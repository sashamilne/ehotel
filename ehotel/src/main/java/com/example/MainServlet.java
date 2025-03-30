package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dbtest")
public class MainServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        try {
            // Get database connection from JNDI
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ehotelDB");
            Connection conn = ds.getConnection();

            // Sample SQL query
            String sql = "SELECT NOW() AS current_time";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            // Print query result
            if (rs.next()) {
                response.getWriter().println("<h1>Database Connected!</h1>");
                response.getWriter().println("<p>Current Time: " + rs.getString("current_time") + "</p>");
            }

            // Close connections
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            response.getWriter().println("<h1>Database Connection Failed!</h1>");
            e.printStackTrace(response.getWriter());
        }

        String[] adresses = {
    "218 Martinez Square Suite 110\nWest Mariahaven, MD 80247",
    "PSC 4826, Box 8046\nAPO AE 68375",
    "6775 Judith Lane Suite 436\nLake Jessica, TX 64269",
    "02997 Bray Stream Suite 320\nNorth Kellyburgh, WI 97168",
    "0625 Ballard Centers Apt. 804\nRichardsonside, KS 33310",
    "9252 Ramirez Locks\nWhitakerstad, UT 46800",
    "0731 Ashley Extensions\nEast George, NJ 93480",
    "PSC 8859, Box 4339\nAPO AP 30565",
    "1326 Cassidy Inlet\nTylerville, MH 04697",
    "67438 Gregory Greens Suite 625\nSouth Erik, CO 44196",
    "USCGC Patterson\nFPO AE 37270",
    "USCGC Wagner\nFPO AE 27588",
    "75559 Torres View Apt. 464\nAdamtown, MD 50410",
    "90960 Cole Ridges Suite 140\nEast Jacob, MO 74669",
    "USNV Sandoval\nFPO AE 96081",
    "341 Alyssa Rue Suite 948\nGrayfurt, OK 24461",
    "02501 Jennifer Mountain Apt. 850\nDiazshire, OR 98172",
    "419 Nelson Court Suite 322\nNew Rachelbury, OH 60160",
    "448 Robert Valleys\nNew Matthewfurt, KS 23096",
    "55355 Andrew Fords\nLake Annborough, TX 74453",
    "549 Michelle Turnpike\nJosephtown, OR 22934",
    "27652 Mccarthy Tunnel\nLake Rebeccaton, AK 74808",
    "0250 Horton View Suite 141\nJonesshire, DE 80661",
    "86019 Laurie Station Suite 298\nLake Virginiaton, MH 68354",
    "37022 Erica Lights Suite 826\nNorth Wandaview, AK 21799",
    "3320 Phelps Forest\nBryantburgh, NH 37845",
    "095 Martinez Roads Suite 884\nNorth Georgeshire, WV 93343",
    "7847 Debbie Landing Apt. 044\nSouth Mariostad, CO 01636",
    "928 Claudia Creek\nEast Christinaborough, GA 72021",
    "37246 Jared Fall Apt. 510\nSouth Cynthiafort, WA 01144",
    "USS Moran\nFPO AP 70368",
    "89077 Cobb Path\nSouth Andrea, MS 87350",
    "40526 Kenneth Passage\nSouth Aaron, OR 23830",
    "22405 Powers Crossroad Apt. 117\nRamseyberg, KY 45656",
    "7625 Fletcher Route Suite 369\nNorth Margaret, OR 52755",
    "PSC 3889, Box 8204\nAPO AA 70479",
    "USNS Ross\nFPO AE 57721",
    "48471 Harmon Pine Apt. 218\nFlynnfurt, WY 40850",
    "57824 Morris Brook Suite 650\nSouth Michelle, PW 86285",
    "74466 Valenzuela Underpass Apt. 812\nWalterfort, AR 25054"
};

        for (int i = 1; i <= 5; i++)
        {
            for(int j = 1; j <= 8; j++)
            {
                String sql = "INSERT INTO ehotelschema.hotel (hotel_id, chain_id, hotel_address, phone_number, rating) VALUES (?, ?, ?, ?, ?)";
                try {
                    // Get database connection from JNDI
                    InitialContext ctx = new InitialContext();
                    DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ehotelDB");
                    Connection conn = ds.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    int id = (i-1)*8 + (j-1);
                    stmt.setInt(1, id);
                    stmt.setInt(2, i);
                    int randomphone = (int) (Math.random() * 1000000000); // Random phone number
                    stmt.setString(3, adresses[id]); // Random address
                    stmt.setInt(4, randomphone); // Random rating between 0 and 5
                    stmt.setDouble(5, (int) (Math.random() * 6));
                    stmt.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
