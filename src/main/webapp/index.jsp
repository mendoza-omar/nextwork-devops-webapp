<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calorie Tracker</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            text-align: center;
        }
        .container {
            max-width: 400px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.1);
        }
        input, button {
            margin: 5px;
            padding: 10px;
            width: 80%;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            background: #f4f4f4;
            margin: 5px 0;
            padding: 10px;
            border-radius: 5px;
        }
        canvas {
            max-width: 100%;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Calorie Tracker</h2>
        <form method="post" action="calorieTracker.jsp">
            <input type="date" name="date" required>
            <input type="text" name="food" placeholder="Food Item" required>
            <input type="number" name="calories" placeholder="Calories" required>
            <button type="submit">Add</button>
        </form>
        <h3>Entries</h3>
        <ul>
            <%@ page import="java.util.*, javax.servlet.http.*" %>
            <%
                HttpSession sessionObj = request.getSession();
                List<Map<String, String>> entries = (List<Map<String, String>>) sessionObj.getAttribute("entries");
                if (entries == null) {
                    entries = new ArrayList<>();
                }
                String date = request.getParameter("date");
                String food = request.getParameter("food");
                String calories = request.getParameter("calories");
                if (date != null && food != null && calories != null) {
                    Map<String, String> entry = new HashMap<>();
                    entry.put("date", date);
                    entry.put("food", food);
                    entry.put("calories", calories);
                    entries.add(entry);
                    sessionObj.setAttribute("entries", entries);
                }
                int totalCalories = 0;
                for (Map<String, String> entry : entries) {
                    totalCalories += Integer.parseInt(entry.get("calories"));
                    out.println("<li>" + entry.get("date") + " - " + entry.get("food") + ": " + entry.get("calories") + " calories</li>");
                }
            %>
        </ul>
        <h3>Total Calories: <%= totalCalories %></h3>
        <canvas id="calorieChart"></canvas>
    </div>

    <script>
        let entries = <%= entries.toString() %>;
        let ctx = document.getElementById('calorieChart').getContext('2d');
        let labels = [];
        let datasets = {};
        const colorPalette = ['#FF5733', '#33FF57', '#3357FF', '#FF33A6', '#FFD700', '#8A2BE2'];
        
        entries.forEach(entry => {
            let date = entry.date;
            let calories = parseInt(entry.calories);
            if (!datasets[date]) {
                datasets[date] = { label: date, data: [], backgroundColor: [] };
                labels.push(date);
            }
            datasets[date].data.push(calories);
            datasets[date].backgroundColor.push(colorPalette[labels.length % colorPalette.length]);
        });
        
        let calorieChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: Object.values(datasets)
            },
            options: {
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    </script>
</body>
</html>
