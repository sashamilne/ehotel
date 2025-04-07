const fs = require('fs');

// Room types to choose from
const roomTypes = ['Deluxe Room', 'Standard Room', 'Suite'];

// Function to generate random integer between min and max (inclusive)
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Function to generate random room type
function getRandomRoomType() {
  const index = getRandomInt(0, roomTypes.length - 1);
  return roomTypes[index];
}

// Function to generate the SQL statements
function generateSQL() {
  const sqlStatements = [];
  const numHotels = 40; // 40 hotels

  for (let hotelId = 1; hotelId <= numHotels; hotelId++) {
    for (let roomIndex = 1; roomIndex <= 5; roomIndex++) {
      const roomNumber = roomIndex + (hotelId - 1) * 5; // room numbers count up per hotel
      const roomType = getRandomRoomType();
      const capacity = getRandomInt(2, 5); // Random capacity between 2 and 5
      const price = getRandomInt(150, 300); // Random price between 150 and 300

      const sqlStatement = `
INSERT INTO ehotelschema.room (hotel_id, room_number, room_type, capacity, price)
VALUES (${hotelId}, ${roomNumber}, '${roomType}', ${capacity}, ${price});`;

      sqlStatements.push(sqlStatement);
    }
  }

  return sqlStatements.join('\n');
}

// Write the generated SQL to a file
const sqlFileContent = generateSQL();
fs.writeFileSync('generated_rooms.sql', sqlFileContent, 'utf8');

console.log('SQL file generated: generated_rooms.sql');