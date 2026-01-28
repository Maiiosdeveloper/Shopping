# 🛍️ Shopping App – iOS Assessment Task

This project is an iOS Shopping App assignment implemented using **Clean VIP Architecture**, **Swift Concurrency (async/await + TaskGroup)**, **SwiftData (Offline Cache)**, and **UIKit**.

The app displays a list of products with pagination, skeleton loading, list/grid view switching, and a product details screen.

---

## 📸 Features

### ✅ Products List Screen
- Display products in **Grid** and **List** modes  
- Smooth switching between both layouts  
- **Skeleton + Shimmer loading** before data is ready  
- **Pagination** (“Load more” when scrolling)  
- **Async image loading using TaskGroup**  
- **Zero flickering** and **smooth scroll performance**

---

### 🛰 Networking
- Uses `URLSession` + `async/await`  
- API Endpoint: `https://fakestoreapi.com/products`

---

### 💽 Offline Cache (SwiftData)
- Saves products + images locally  
- Works **offline** when no network is available  
- Syncs automatically when connection returns

---

## 🏗 Architecture

The project uses **Clean VIP**:


### Why VIP?
- Clear separation of concerns  
- Testable  
- Very scalable (suitable for real production apps)  
- Safe for async operations  

---

## 🧩 Technologies Used

- **UIKit**
- **Swift Concurrency**
- **
