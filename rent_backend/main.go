package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"rent_backend/data"
)

func main() {
	http.HandleFunc("/api/tenant/dashboard", tenantDashboard)

	http.HandleFunc("/api/landlord/payment", updatePayment)
	http.HandleFunc("/api/landlord/electricity", updateElectricity)
	http.HandleFunc("/api/landlord/water", updateWater)

	log.Println("Rent backend running on http://localhost:8080")

	err := http.ListenAndServe(":8080", nil)

	if err != nil {
		log.Fatal(err)
	}
}

func enableCORS(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set(
		"Access-Control-Allow-Methods",
		"GET, POST, PUT, DELETE, OPTIONS",
	)
	w.Header().Set(
		"Access-Control-Allow-Headers",
		"Content-Type, Authorization",
	)
}

func tenantDashboard(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(data.TenantData)
}

func updatePayment(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var payment data.Payment

	err := json.NewDecoder(r.Body).Decode(&payment)

	if err != nil {
		http.Error(w, "Invalid payment data", http.StatusBadRequest)
		return
	}

	payment.Total = payment.Rent + payment.Electricity

	found := false

	for i := range data.TenantData.Payments {
		if data.TenantData.Payments[i].Month == payment.Month &&
			data.TenantData.Payments[i].Year == payment.Year {

			data.TenantData.Payments[i] = payment
			found = true
			break
		}
	}

	if !found {
		data.TenantData.Payments = append(
			[]data.Payment{payment},
			data.TenantData.Payments...,
		)
	}

	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(payment)
}

func updateElectricity(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var appliance data.Appliance

	err := json.NewDecoder(r.Body).Decode(&appliance)

	if err != nil {
		http.Error(w, "Invalid appliance data", http.StatusBadRequest)
		return
	}

	appliance.UpdatedAt = time.Now().Format("02 January 2006")

	found := false

	for i := range data.TenantData.Appliances {
		if data.TenantData.Appliances[i].Name == appliance.Name {

			data.TenantData.Appliances[i] = appliance
			found = true
			break
		}
	}

	if !found {
		data.TenantData.Appliances = append(
			data.TenantData.Appliances,
			appliance,
		)
	}

	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(appliance)
}

func updateWater(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var water data.WaterSupply

	err := json.NewDecoder(r.Body).Decode(&water)

	if err != nil {
		http.Error(w, "Invalid water data", http.StatusBadRequest)
		return
	}

	water.UpdatedAt = time.Now().Format("02 January 2006")

	data.TenantData.Water = water

	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(water)
}
