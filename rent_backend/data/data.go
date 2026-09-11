package data

type Payment struct {
	Month       string  `json:"month"`
	Year        int     `json:"year"`
	Rent        float64 `json:"rent"`
	Electricity float64 `json:"electricity"`
	Total       float64 `json:"total"`
	PaymentDate string  `json:"paymentDate"`
	Status      string  `json:"status"`
}

type Appliance struct {
	Name      string `json:"name"`
	Status    string `json:"status"`
	Note      string `json:"note"`
	UpdatedAt string `json:"updatedAt"`
}

type WaterSupply struct {
	Status    string `json:"status"`
	Note      string `json:"note"`
	UpdatedAt string `json:"updatedAt"`
}

type Tenant struct {
	ID         int         `json:"id"`
	Name       string      `json:"name"`
	Property   string      `json:"property"`
	Unit       string      `json:"unit"`
	Payments   []Payment   `json:"payments"`
	Appliances []Appliance `json:"appliances"`
	Water      WaterSupply `json:"water"`
}

var TenantData = Tenant{
	ID:       1,
	Name:     "Rahul",
	Property: "Green Residency",
	Unit:     "Flat 302",

	Payments: []Payment{
		{
			Month:       "September",
			Year:        2026,
			Rent:        12000,
			Electricity: 1250,
			Total:       13250,
			PaymentDate: "05 September 2026",
			Status:      "Paid",
		},
		{
			Month:       "August",
			Year:        2026,
			Rent:        12000,
			Electricity: 1100,
			Total:       13100,
			PaymentDate: "05 August 2026",
			Status:      "Paid",
		},
		{
			Month:       "July",
			Year:        2026,
			Rent:        12000,
			Electricity: 1000,
			Total:       13000,
			PaymentDate: "05 July 2026",
			Status:      "Paid",
		},
	},

	Appliances: []Appliance{
		{
			Name:      "Fan",
			Status:    "Working",
			Note:      "",
			UpdatedAt: "05 September 2026",
		},
		{
			Name:      "AC",
			Status:    "Problem",
			Note:      "AC is not cooling properly.",
			UpdatedAt: "05 September 2026",
		},
		{
			Name:      "Geyser",
			Status:    "Under Repair",
			Note:      "Technician has been contacted.",
			UpdatedAt: "05 September 2026",
		},
		{
			Name:      "Lights",
			Status:    "Working",
			Note:      "",
			UpdatedAt: "05 September 2026",
		},
	},

	Water: WaterSupply{
		Status:    "Normal",
		Note:      "Water supply is normal.",
		UpdatedAt: "05 September 2026",
	},
}
