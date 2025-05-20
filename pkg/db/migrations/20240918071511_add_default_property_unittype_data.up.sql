-- usage bigint
-- Residential
-- Commercial
-- Agricultural
-- Industrial (not for swap)


INSERT INTO property_type(
    type,code,property_type_facts,usage,created_at,updated_at,icon
)VALUES('Hotel Apartment','HA', '{
    "sale": [
        {
            "id": 1,
            "title": "Plot Area",
            "slug": "plot_area",
            "icon": "dfsdfasd"
        },
        {
            "id": 2,
            "title": "Built up Area",
            "slug": "build_area",
            "icon": "dfsdfasd"
        }
    ],
    "rent": [
        {
            "id": 1,
            "title": "Plot Area",
            "slug": "plot_area",
            "icon": "dfsdfasd"
        },
        {
            "id": 2,
            "title": "Built up Area",
            "slug": "build_area",
            "icon": "dfsdfasd"
        }
    ],
    "swap": [
        {
            "id": 1,
            "title": "Plot Area",
            "slug": "plot_area",
            "icon": "dfsdfasd"
        },
        {
            "id": 2,
            "title": "Built up Area",
            "slug": "build_area",
            "icon": "dfsdfasd"
        }
    ]
}',1,now(),now(),'urlhere'),
('Villa','VI','{
            "sale": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'),
('Apartment','AP', '{
            "sale": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'),
('TownHouse','TH','{
            "sale": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'),
('PentHouse','PH', '{
            "sale": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Plot Area",
                    "slug": "plot_area",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Built up Area",
                    "slug": "build_area",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere');

INSERT INTO unit_type(
    type,code,facts,usage,created_at,updated_at,icon
)
VALUES(
    'Hotel Apartment','HA','{
            "sale": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'
),
(
    'Villa','VI', '{
            "sale": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'
),
(
    'Apartment','AP','{
            "sale": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'
),
(
    'TownHouse','TH','{
            "sale": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'
),
(
    'PentHouse','PH','{
            "sale": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "rent": [
                {
                    "id": 1,
                    "title": "Bedroom",
                    "slug": "bedroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ],
            "swap": [
                {
                    "id": 1,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                },
                {
                    "id": 2,
                    "title": "Bathroom",
                    "slug": "bathroom",
                    "icon": "dfsdfasd"
                }
            ]
        }',1,now(),now(),'urlhere'
);