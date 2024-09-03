namespace app.interactions;
entity StatusOptions {
    key code : String(20);
    name : String(50);
}

entity CloseCategoryOptions {
    key code : String(20);
    name : String(50);
}

entity AnomalyDetection {
    key id             : Integer;
    company_code       : String(10) not null;
    process_area       : String(10) not null;
    data_key           : String(255) not null;
    model_name         : String(50) not null;
    score              : Integer not null;
    status             : Association to StatusOptions not null;
    identified_date    : Date not null;
    last_update        : Date;
    assignee           : String(50);
    notes              : String(500);
    close_category     : Association to CloseCategoryOptions;
}
