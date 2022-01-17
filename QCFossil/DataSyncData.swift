//
//  DataSyncData.swift
//  QCFossil
//
//  Created by Yin Huang on 4/5/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

//Data Sync Server
#if DEBUG
let dataSyncServerUsing = dataSyncTestServer
#else
let dataSyncServerUsing = dataSyncPrdServer
#endif

let dataSyncTestServer = "https://web01.forrus.com.hk/test_ws_quality/" //"http://202.123.87.16/test_ws_quality/"
let dataSyncUatServer = "https://web01.forrus.com.hk/uat_ws_quality/" //"http://202.123.87.16/uat_ws_quality/"
let dataSyncPrdServer = "https://quality.forrus.com.hk/ws_quality/"
let _DS_PREFIX = "req_msg="
let _DS_USERNAME = "uName"
let _DS_USERPASSWORD = "uPw"
var _DS_SESSION = "ds_session"
let _DS_RESETEMAIL = "reset_email"
var _DS_SERVICETOKEN = "DDFF2FAA-A256-4A87-8C23-AB651AFCD561"//will be updated when user login
var _DS_UPLOADEDTASKCOUNT = 0

//Total Records Obj
var _DS_RECORDS:Dictionary<String, [String]> = [
    "_DS_MSTRDATA" : [String](),
    "_DS_INPTSETUP" : [String](),
    "_DS_FGPODATA" : [String](),
    "_DS_TASKDATA" : [String]()
]

var _DS_TOTALRECORDS_DB:Dictionary<String, String> = [
    "task_inspect_data_record_count" : "0",
    "inspect_task_item_count" : "0",
    "inspect_task_count" : "0",
    "inspect_task_qc_info_count" : "0",
    "task_defect_data_record_count" : "0",
    "task_inspect_photo_file_count" : "0",
    "task_inspect_position_point_count" : "0",
    "task_inspect_field_value_count" : "0",
    "inspect_task_inspector_count" : "0"
]

//User Login, Forget Username, Forget Password
let _DS_USERLOGIN = [
    "NAME" : "Inspector Authentication",
    "APINAME" : "\(dataSyncServerUsing)req_inspector_auth.aspx",
    "APIPARA" : [
        "service_type" : "Inspector Authentication",
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "action_type": "user_login",
        "app_username": _DS_USERNAME,
        "app_password": _DS_USERPASSWORD
    ],
    "ACTIONNAMES" : [
        "inspector_mstr",
        "prod_type_mstr"
    ],
    "ACTIONTABLES" : [
        "inspector_mstr" : "inspector_mstr",
        "prod_type_mstr" : "prod_type_mstr"
    ],
    "ACTIONFIELDS" : [
        "inspector_mstr" : [
            "inspector_id",
            "inspector_name",
            "prod_type_id",
            "app_username",
            "app_password",
            "service_token",
            "report_prefix",
            "report_running_no",
            "phone_no",
            "email_addr",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "chg_pwd_req_date"
        ],
        "prod_type_mstr" : [
            "type_id",
            "type_code",
            "type_name_en",
            "type_name_cn",
            "data_env",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "type_name_fr"
        ]
    ]
] as [String : Any]

let _DS_FORGET_UN = [
    "NAME" : "Inspector Authentication",
    "APINAME" : "\(dataSyncServerUsing)req_inspector_auth.aspx",
    "APIPARA" : [
        "service_type" : "Inspector Authentication",
        "device_id" : UIDevice.current.identifierForVendor!.uuidString,
        "action_type": "forget_username",
        "email" : _DS_RESETEMAIL
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

let _DS_FORGET_UNPW = [
    "NAME" : "Inspector Authentication",
    "APINAME" : "\(dataSyncServerUsing)req_inspector_auth.aspx",
    "APIPARA" : [
        "service_type" : "Inspector Authentication",
        "device_id" : UIDevice.current.identifierForVendor!.uuidString,
        "action_type": "forget_password",
        "app_username": _DS_USERNAME,
        "email": _DS_RESETEMAIL
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

let _DS_CHANGE_PW = [
    "NAME" : "Inspector Authentication",
    "APINAME" : "\(dataSyncServerUsing)req_inspector_auth.aspx",
    "APIPARA" : [
        "service_type" : "Inspector Authentication",
        "service_token": _DS_SERVICETOKEN,
        "device_id" : UIDevice.current.identifierForVendor!.uuidString,
        "action_type" : "change_password",
        "decrypt_app_password" : "new_password"
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//Master Data Download
let _DS_MSTRDATA = [
    "NAME" : "Master Data Download",
    "APINAME" : "\(dataSyncServerUsing)dl_mstr_data.aspx",
    "ACKNAME" : _DS_ACKMSTRDATA,
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type" : "Master Data Download"
    ],
    "ACTIONNAMES" : [
        "brand_mstr_list",
        "prod_type_mstr_list",
        "vdr_brand_map_list",
        "vdr_location_mstr_list",
        "vdr_mstr_list"
    ],
    "ACTIONTABLES" : [
        "brand_mstr_list" : "brand_mstr",
        "prod_type_mstr_list" : "prod_type_mstr",
        "vdr_brand_map_list" : "vdr_brand_map",
        "vdr_location_mstr_list" : "vdr_location_mstr",
        "vdr_mstr_list" : "vdr_mstr"
    ],    
    "ACTIONFIELDS" : [
        "brand_mstr_list" : [
            "brand_code",
            "brand_id",
            "brand_name",
            "create_date",
            "create_user",
            "data_env",
            "delete_date",
            "delete_user",
            "deleted_flag",
            "modify_date",
            "modify_user",
            "rec_status"
        ],
        "prod_type_mstr_list" : [
            "create_date",
            "create_user",
            "data_env",
            "delete_date",
            "delete_user",
            "deleted_flag",
            "modify_date",
            "modify_user",
            "rec_status",
            "type_code",
            "type_id",
            "type_name_en",
            "type_name_cn"
        ],
        "vdr_brand_map_list" : [
            "brand_id",
            "create_date",
            "create_user",
            "data_env",
            "modify_date",
            "modify_user",
            "vdr_id"
        ],
        "vdr_location_mstr_list" : [
            "create_date",
            "create_user",
            "data_env",
            "delete_date",
            "delete_user",
            "deleted_flag",
            "location_code",
            "location_id",
            "location_name",
            "modify_date",
            "modify_user",
            "rec_status",
            "vdr_id",
            "vdr_sign_name"
        ],
        "vdr_mstr_list" : [
            "contact_addr",
            "contact_email",
            "contact_person",
            "contact_phone",
            "create_date",
            "create_user",
            "data_env",
            "delete_date",
            "delete_user",
            "deleted_flag",
            "display_name",
            "modify_date",
            "modify_user",
            "rec_status",
            "vdr_code",
            "vdr_id",
            "vdr_name"
        ]
    ]
] as [String : Any]

//Master Data Download Acknowledgement
let _DS_ACKMSTRDATA = [
    "NAME" : "Master Data Download Acknowledgement",
    "APINAME" : "\(dataSyncServerUsing)ack_mstr_data.aspx",
    "APIPARA" : [
        "service_token" :_DS_SERVICETOKEN,
        "service_session" :_DS_SESSION,
        "prod_type_mstr_count" :"0",
        "vdr_mstr_count" :"0",
        "vdr_location_mstr_count" : "0",
        "brand_mstr_count" : "0",
        "vdr_brand_map_count" :"0"
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//Inspection Setup Data Download
let _DS_INPTSETUP = [
    "NAME" : "Inspection Setup Data Download",
    "APINAME" : "\(dataSyncServerUsing)dl_setup_data.aspx",
    "ACKNAME" : _DS_ACKINPTSETUP,
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type" : "Inspection Setup Data Download"
    ],
    "ACTIONNAMES" : [
        "inspect_type_mstr_list",
        "inspect_setup_mstr_list",
        "inspect_task_tmpl_mstr_list",
        "inspect_task_tmpl_field_list",
        "inspect_task_tmpl_section_list",
        "inspect_task_tmpl_position_list",
        "inspect_task_field_mstr_list",
        "inspect_task_field_select_val_list",
        "inspect_section_mstr_list",
        "inspect_section_element_list",
        "inspect_position_mstr_list",
        "inspect_position_element_list",
        "inspect_element_mstr_list",
        "inspect_element_detail_select_val_list",
        "result_value_mstr_list",
        "result_set_mstr_list",
        "result_set_value_list",
        "zone_value_mstr_list",
        "zone_set_mstr_list",
        "zone_set_value_list",
        "case_value_mstr_list",
        "case_set_mstr_list",
        "case_set_value_list",
        "defect_value_mstr_list",
        "defect_set_mstr_list",
        "defect_set_value_list",
        "task_selection_option_mstr_list"
    ],
    "ACTIONTABLES" : [
        "inspect_type_mstr_list" : "inspect_type_mstr",
        "inspect_setup_mstr_list" : "inspect_setup_mstr",
        "inspect_section_mstr_list" : "inspect_section_mstr",
        "inspect_position_mstr_list" : "inspect_position_mstr",
        "inspect_element_mstr_list" : "inspect_element_mstr",
        "inspect_element_detail_select_val_list" : "inspect_element_detail_select_val",
        "result_value_mstr_list" : "result_value_mstr",
        "result_set_mstr_list" : "result_set_mstr",
        "result_set_value_list" : "result_set_value",
        "inspect_task_tmpl_mstr_list" : "inspect_task_tmpl_mstr",
        "inspect_task_field_mstr_list" : "inspect_task_field_mstr",
        "inspect_task_field_select_val_list" : "inspect_task_field_select_val",
        "inspect_task_tmpl_field_list" : "inspect_task_tmpl_field",
        "inspect_task_tmpl_section_list" : "inspect_task_tmpl_section",
        "inspect_task_tmpl_position_list" : "inspect_task_tmpl_position",
        "inspect_section_element_list" : "inspect_section_element",
        "inspect_position_element_list" : "inspect_position_element",
        "zone_value_mstr_list" : "zone_value_mstr",
        "zone_set_mstr_list" : "zone_set_mstr",
        "zone_set_value_list" : "zone_set_value",
        "case_value_mstr_list" : "case_value_mstr",
        "case_set_mstr_list" : "case_set_mstr",
        "case_set_value_list" : "case_set_value",
        "defect_value_mstr_list" : "defect_value_mstr",
        "defect_set_mstr_list" : "defect_set_mstr",
        "defect_set_value_list" : "defect_set_value",
        "task_selection_option_mstr_list" : "task_selection_option_mstr"
    ],
    "ACTIONFIELDS" : [
        "inspect_type_mstr_list" : [
            "type_id",
            "type_code",
            "type_name_en",
            "type_name_cn",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "type_name_fr"
        ],
        "inspect_setup_mstr_list" : [
            "setup_id",
            "ver_code",
            "ver_name",
            "effect_date_from",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user"
        ],
        "inspect_task_tmpl_mstr_list": [
            "tmpl_id",
            "inspect_setup_id",
            "tmpl_code",
            "tmpl_name_en",
            "tmpl_name_cn",
            "prod_type_id",
            "inspect_type_id",
            "result_set_id",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "tmpl_name_fr"
        ],
        "inspect_task_tmpl_field_list": [
            "tmpl_id",
            "inspect_field_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "inspect_task_tmpl_section_list": [
            "tmpl_id",
            "inspect_section_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "inspect_task_tmpl_position_list": [
            "tmpl_id",
            "inspect_position_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "inspect_task_field_mstr_list": [
            "field_id",
            "field_name_en" ,
            "field_name_cn",
            "prod_type_id",
            "inspect_type_id",
            "display_order",
            "field_type",
            "field_length",
            "numeric_scale",
            "field_default_value",
            "required_field_flag",
            "business_logic_code",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "field_name_fr"
        ],
        "inspect_task_field_select_val_list": [
            "val_id",
            "field_id",
            "select_val",
            "select_text_en",
            "select_text_cn",
            "is_default_flag",
            "val_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "select_text_fr"
        ],
        "inspect_section_mstr_list" : [
            "section_id",
            "section_name_en",
            "section_name_cn",
            "prod_type_id",
            "inspect_type_id",
            "display_order",
            "result_set_id",
            "input_mode_code",
            "optional_enable_flag",
            "adhoc_select_flag",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "section_name_fr"
        ],
        "inspect_section_element_list" : [
            "inspect_section_id",
            "inspect_element_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "inspect_position_mstr_list" : [
            "position_id",
            "position_code",
            "position_name_en",
            "position_name_cn",
            "prod_type_id",
            "inspect_type_id",
            "current_level",
            "parent_position_id",
            "position_type",
            "position_zone_set_id",
            "display_order",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "position_name_fr"
        ],
        "inspect_position_element_list" : [
            "inspect_position_id",
            "inspect_element_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "inspect_element_mstr_list" : [
            "element_id",
            "element_name_en",
            "element_name_cn",
            "prod_type_id",
            "inspect_type_id",
            "element_type",
            "display_order",
            "result_set_id",
            "required_element_flag",
            "detail_default_value",
            "detail_required_result_set_id",
            "detail_suggest_flag",
            "inspect_defect_set_id",
            "inspect_case_set_id",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "element_name_fr"
        ],
        "inspect_element_detail_select_val_list" : [
            "val_id",
            "element_id",
            "select_val",
            "select_text_en",
            "select_text_cn",
            "is_default_flag",
            "val_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "select_text_fr"
        ],
        "result_value_mstr_list" : [
            "value_id",
            "value_code",
            "value_name_en",
            "value_name_cn",
            "display_order",
            "defect_gen_flag",
            "auto_approve_flag",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "value_name_fr"
        ],
        "result_set_mstr_list" :[
            "set_id",
            "set_name",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user"
        ],
        "result_set_value_list": [
            "set_id",
            "value_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "zone_value_mstr_list" : [
            "value_id",
            "value_code",
            "value_name_en",
            "value_name_cn",
            "display_order",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "value_name_fr"
        ],
        "zone_set_mstr_list" : [
            "set_id",
            "set_name",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user"
        ],
        "zone_set_value_list" : [
            "set_id",
            "value_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        
        ],
        "case_value_mstr_list" : [
            "value_id",
            "value_code",
            "value_name_en",
            "value_name_cn",
            "display_order",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "value_name_fr"
        ],
        "case_set_mstr_list" : [
            "set_id",
            "set_name",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user"
        ],
        "case_set_value_list" : [
            "set_id",
            "value_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "defect_value_mstr_list" : [
            "value_id",
            "value_code",
            "value_name_en",
            "value_name_cn",
            "display_order",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "value_name_fr"
        ],
        "defect_set_mstr_list" : [
            "set_id",
            "set_name",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user"
        ],
        "defect_set_value_list" : [
            "set_id",
            "value_id",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "task_selection_option_mstr_list" : [
            "option_id",
            "data_env",
            "selection_type",
            "result_code_match_list",
            "option_val",
            "option_text_en",
            "option_text_zh",
            "display_order",
            "rec_status",
            "create_user",
            "create_date",
            "modify_user",
            "modify_date",
            "deleted_flag",
            "delete_user",
            "delete_date",
            "option_text_fr"
        ]
    ]
] as [String : Any]

//Inspection Setup Data Download Acknowledgement
let _DS_ACKINPTSETUP = [
    "NAME" : "Inspection Setup Data Download Acknowledgement",
    "APINAME" : "\(dataSyncServerUsing)ack_setup_data.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "service_session": _DS_SESSION,
        "inspect_type_mstr_count": "0",
        "inspect_setup_mstr_count": "0",
        "inspect_task_tmpl_mstr_count": "0",
        "inspect_task_tmpl_field_count": "0",
        "inspect_task_tmpl_section_count": "0",
        "inspect_task_tmpl_position_count": "0",
        "inspect_task_field_mstr_count": "0",
        "inspect_task_field_select_val_count": "0",
        "inspect_section_mstr_count": "0",
        "inspect_section_element_count": "0",
        "inspect_position_mstr_count": "0",
        "inspect_position_element_count": "0",
        "inspect_element_mstr_count": "0",
        "inspect_element_detail_select_val_count": "0",
        "result_value_mstr_count": "0",
        "result_set_mstr_count": "0",
        "result_set_value_count": "0",
        "zone_value_mstr_count" : "0",
        "zone_set_mstr_count" : "0",
        "zone_set_value_count" : "0",
        "case_value_mstr_count" : "0",
        "case_set_mstr_count" : "0",
        "case_set_value_count" : "0",
        "defect_value_mstr_count" : "0",
        "defect_set_mstr_count" : "0",
        "defect_set_value_count" : "0",
        "task_selection_option_mstr_count" : "0"
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//FGPO Data Download Request
let _DS_FGPODATA = [
    "NAME" : "FGPO Data Download",
    "APINAME" : "\(dataSyncServerUsing)dl_fgpo_data.aspx",
    "ACKNAME" : _DS_ACKFGPODATA,
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type": "FGPO Data Download",
        "init_service_session": ""
    ],
    
    "ACTIONNAMES" : [
        "fgpo_line_item_list"
    ],
    
    "ACTIONTABLES" : [
        "fgpo_line_item_list" : "fgpo_line_item"
    ],
    
    "ACTIONFIELDS" : [
        "fgpo_line_item_list": [
            "item_id",
            "data_env",
            "ref_head_id",
            "po_no",
            "ref_buyer_id",
            "buyer_code",
            "buyer_name",
            "buyer_display_name",
            "ref_vdr_id",
            "vdr_code",
            "vdr_name",
            "vdr_display_name",
            "ref_line_id",
            "po_line_no",
            "ship_mode_name",
            "ref_prod_id",
            "sku_no",
            "prod_type_code",
            "style_no",
            "dimen_1",
            "dimen_2",
            "dimen_3",
            "ref_vdr_location_id",
            "vdr_location_code",
            "vdr_location_name",
            "ref_buyer_location_id",
            "buyer_location_code", // ship to
            "buyer_location_name",
            "ref_order_no",
            "ref_order_line",
            "ref_brand_id",
            "brand_code",
            "brand_name",
            "req_deliv_date",
            "ship_win",
            "promised_ship_date_start",
            "promised_ship_date_end",
            "sched_ship_date_start",
            "sched_ship_date_end",
            "line_sched_text", // opd/rsd
            "line_sched_date_start",
            "line_sched_date_end",
            "order_qty",
            "outstand_qty",
            "line_qty_uom",
            "line_status",
            "qc_booked_qty",
            "app_ready_purge_date", //add 1107
            "create_date",
            "modify_date",
            "deleted_flag",
            "delete_date",
            "prod_desc",
            "material_category",
            "market"
        ]
    ]
] as [String : Any]
//FGPO Data Download Acknowledgement
let _DS_ACKFGPODATA = [
    "NAME" : "FGPO Data Download Acknowledgement",
    "APINAME" : "\(dataSyncServerUsing)ack_fgpo_data.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "service_session": _DS_SESSION,
        "fgpo_line_item_count": "0"
    ],
    
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//Task Booking Data Download
let _DS_TASKDATA = [
    "NAME" : "Task Booking Data Download",
    "APINAME" : "\(dataSyncServerUsing)dl_task_data.aspx",
    "ACKNAME" : _DS_ACKTASKDATA,
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type": "Task Booking Data Download",
    ],
    
    "ACTIONNAMES" : [
        "inspect_task_list",
        "inspect_task_inspector_list",
        "inspect_task_item_list",
        "inspect_task_qc_info_list"
    ],
    
    "ACTIONTABLES" : [
        "inspect_task_list" : "inspect_task",
        "inspect_task_inspector_list" : "inspect_task_inspector",
        "inspect_task_item_list" : "inspect_task_item",
        "inspect_task_qc_info_list" : "inspect_task_qc_info"
    ],
    
    "ACTIONFIELDS" : [
        "inspect_task_list": [
            "ref_task_id",
            "prod_type_id",
            "inspect_type_id",
            "booking_no",
            "booking_date",
            "vdr_location_id",
            "report_inspector_id",
            "report_prefix",
            "report_running_no",
            "inspection_no",
            "inspection_date",
            "inspect_setup_id",
            "tmpl_id",
            "task_remarks",
            "vdr_notes",
            "qc_remarks_option_list",
            "additional_admin_item_option_list",
            "inspect_result_value_id",
            "inspector_sign_image_file",
            "vdr_sign_name",
            "vdr_sign_image_file",
            "task_status",
            "rec_status",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user"
        ],
        "inspect_task_inspector_list": [
            "ref_task_id",
            "inspector_id",
            "inspect_enable_flag",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user"
        ],
        "inspect_task_item_list": [
            "ref_task_id",
            "po_item_id",
            "ref_qc_plan_line_id",
            "target_inspect_qty",
            "avail_inspect_qty",
            "sampling_qty",
            "inspect_enable_flag",
            "item_barcode",
            "retail_price",
            "currency",
            "create_date",
            "create_user",
            "modify_date",
            "modify_user",
            "style_size",
            "substr_style_size"
        ],
        "inspect_task_qc_info_list" : [
            "ref_task_id",
            "aql_qty",
            "product_class",
            "quality_standard",
            "adjust_time",
            "preinspect_detail",
            "ca_form",
            "caseback_marking",
            "upc_orbid_status",
            "ts_report_no",
            "ts_submit_date",
            "ts_result",
            "qc_booking_ref_no",
            "ss_comment_ready",
            "ss_ready",
            "ss_photo_name",
            "battery_production_code",
            "with_quesiton_pending",
            "wth_same_po_rejected_bef",
            "assortment",
            "consigned_styles",
            "qc_inspect_type",
            "net_weight",
            "inspect_method",
            "length_requirement",
            "inspection_sample_ready",
            "fty_packing_info",
            "fty_droptest_info",
            "movt_origin",
            "battery_type",
            "pre_inspect_result",
            "pre_inspect_remark",
            "reliability_remark",
            "jwl_marking",
            "combine_qc_remarks",
            "links_remarks",
            "dusttest_remark",
            "smartlink_remark",
            "precise_report",
            "smartlink_report",
            "create_user",
            "create_date",
            "modify_user",
            "modify_date",
            "inspector_names",
            "substr_inspector_names",
            "substr_quality_standard",
            "substr_length_requirement",
            "substr_movt_origin",
            "substr_combine_qc_remarks",
            "substr_ss_ready",
            "substr_pre_inspect_remark",
            "substr_ss_comment_ready",
            "substr_ca_form",
            "substr_reliability_remark"
        ]
    ]
] as [String : Any]

//Task Booking Data Download Acknowledgement
let _DS_ACKTASKDATA = [
    "NAME" : "Task Booking Data Download Acknowledgement",
    "APINAME" : "\(dataSyncServerUsing)ack_task_data.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "service_session": _DS_SESSION,
        "inspect_task_count": "0",
        "inspect_task_inspector_count": "0",
        "inspect_task_item_count": "0",
        "inspect_task_qc_info_count" : "0"
    ],
    
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//Task Status Data Download Request
let _DS_DL_TASK_STATUS = [
    "NAME" : "Task Status Data Download",
    "APINAME" : "\(dataSyncServerUsing)dl_task_status_ws3.aspx",
    "ACKNAME" : _DS_ACKTASKSTATUS,
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type": "Task Status Data Download",
    ],
    
    "ACTIONNAMES" : [
        "inspect_task_list"
    ],
    "ACTIONTABLES" : [
        "inspect_task_list" : "inspect_task"
    ],
    "ACTIONFIELDS" : [
        "inspect_task_list" : [
            "task_id", //Add 1107
            "ref_task_id",
            "inspect_result_value_id",
            "task_status",
            "review_remarks",
            "review_user",
            "review_date",
            "app_ready_purge_date", //add 1107
            "rec_status",
            "modify_date",
            "modify_user",
            "deleted_flag",
            "delete_date",
            "delete_user",
            "inspection_no",//add 0820
            "inspection_date"//add 0820
        ]
    ]
] as [String : Any]

//Task Status Data Download Acknowledgement
let _DS_ACKTASKSTATUS = [
    "NAME" : "Task Status Data Download Acknowledgement",
    "APINAME" : "\(dataSyncServerUsing)ack_task_status.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "service_session": _DS_SESSION,
        "inspect_task_count": "0"
    ],
    
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//Style Photo Data Download Request
let _DS_DL_STYLE_PHOTO = [
    "NAME" : "Style Photo Download",
    "APINAME" : "\(dataSyncServerUsing)dl_style_photo.aspx",
    "ACKNAME" : _DS_ACKSTYLEPHOTO,
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type": "Style Photo Download",
    ],
    "ACTIONNAMES" : [
        "style_photo_list"
    ],
    "ACTIONTABLES" : [
        "style_photo_list" : "style_photo"
    ],
    "ACTIONFIELDS" : [
        "style_photo_list" : [
            "photo_id",
            "data_env",
            "style_no",
            "ss_photo_name",
            "ss_photo_file",
            "cb_photo_name",
            "cb_photo_file",
            "create_date",
            "modify_date",
            "deleted_flag",
            "delete_date"
        ]
    ]
] as [String : Any]

//Style Photo Data Download Acknowledgement
let _DS_ACKSTYLEPHOTO = [
    "NAME" : "Style Photo Download Acknowledgement",
    "APINAME" : "\(dataSyncServerUsing)ack_style_photo.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "service_session": _DS_SESSION,
        "style_photo_count": "0"
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//App Database Backup Upload
let _DS_UPLOADDBBACKUP = [
    "NAME" : "App Database Backup Upload",
    "APINAME" : "\(dataSyncServerUsing)ul_db_backup.aspx",
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id" : UIDevice.current.identifierForVendor!.uuidString,
        "db_filename" : "fossil_qc_prd.sqlite",
        "db_file" : "fossil_qc_prd.sqlite",
        "backup_remarks" : "",
        "app_version" : "",
        "app_release" : ""
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

let _DS_LISTDBBACKUP = [
    "NAME" : "App Database Backup History",
    "APINAME" : "\(dataSyncServerUsing)list_db_backup.aspx",
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id" : UIDevice.current.identifierForVendor!.uuidString,
        "service_type" : "App Database Backup History",
        "app_version" : "",
        "app_release" : ""
    ],
    "RESPONSEFIELDS" : [
        "app_db_backup_list"
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "app_db_backup_list" : [
            "backup_sync_id",
            "device_id",
            "backup_process_date",
            "backup_remarks",
            "app_version",
            "app_release"
        ]
    ]
] as [String : Any]

let _DS_DBBACKUPDOWNLOAD = [
    "NAME" : "App Database Backup Download",
    "APINAME" : "\(dataSyncServerUsing)dl_db_backup.aspx",
    "APIPARA" : [
        "service_token" : _DS_SERVICETOKEN,
        "device_id" : UIDevice.current.identifierForVendor!.uuidString,
        "service_type" : "App Database Backup Download",
        "backup_sync_id" : ""
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]

//Task Result Data Upload
let _DS_ULTASKDATA = [
    "NAME" : "Task Result Data Upload",
    "APINAME" : "\(dataSyncServerUsing)ul_task_data.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type": "Task Result Data Upload",
    ],
    
    "RESPONSEFIELDS" : [
        "service_session",
        "inspect_task_count",
        "inspect_task_inspector_count",
        "inspect_task_item_count",
        "task_inspect_field_value_count",
        "task_inspect_data_record_count",
        "task_inspect_position_point_count",
        "task_defect_data_record_count",
        "task_inpect_photo_file_count",
        "task_status_list"
    ],
    
    "ACTIONNAMES" : [
        "inspect_task_list",
        "inspect_task_inspector_list",
        "inspect_task_item_list",
        "task_inspect_field_value_list",
        "task_inspect_data_record_list",
        "task_inspect_position_point_list",
        "task_defect_data_record_list",
        "task_inspect_photo_file_list"
    ],
    
    "ACTIONTABLES" : [
        "inspect_task_list" : "inspect_task",
        "inspect_task_inspector_list" : "inspect_task_inspector",
        "inspect_task_item_list" : "inspect_task_item",
        "task_inspect_field_value_list" : "task_inspect_field_value",
        "task_inspect_data_record_list" : "task_inspect_data_record",
        "task_inspect_position_point_list" : "task_inspect_position_point",
        "task_defect_data_record_list": "task_defect_data_record",
        "task_inspect_photo_file_list" : "task_inspect_photo_file"
    ],
    
    "ACTIONFIELDS" : [
        "inspect_task_list": [
            "task_id" : "",
            "prod_type_id" : "",
            "inspect_type_id" : "",
            "booking_no" : "",
            "booking_date" : "",
            "vdr_location_id" : "",
            "report_inspector_id" : "",
            "report_prefix" : "",
            "report_running_no" : "",
            "inspection_no" : "",
            "inspection_date" : "",
            "task_remarks" : "",
            "vdr_notes" : "",
            "inspect_result_value_id" : "",
            "inspector_sign_image_file" : "",
            "vdr_sign_name" : "",
            "vdr_sign_image_file" : "",
            "task_status" : "",
            "upload_inspector_id" : "",
            "ref_task_id" : "",
            "rec_status" : "",
            "create_user" : "",
            "create_date" : "",
            "modify_user" : "",
            "modify_date" : "",
            "deleted_flag" : "",
            "delete_user" : "",
            "delete_date" : "",
            "inspect_setup_id" : "",
            "vdr_sign_date" : "",
            "tmpl_id" : "",
            "data_refuse_desc" : "",
            "app_ready_purge_date" : "",
            "review_remarks" : "",
            "review_user" : "",
            "review_date" : "",
            "cancel_date" : "",
            "confirm_upload_date" : "",
            "qc_remarks_option_list" : "",
            "additional_admin_item_option_list" : ""
        ],
        "inspect_task_inspector_list": [
            "task_id" : "",
            "inspector_id" : "",
            "inspect_enable_flag" : "",
            "create_date" : "",
            "create_user" : "",
            "modify_date" : "",
            "modify_user" : ""
        ],
        "inspect_task_item_list": [
            "task_id" : "",
            "po_item_id" : "",
            "target_inspect_qty" : "",
            "avail_inspect_qty" : "",
            "inspect_enable_flag" : "",
            "create_user" : "",
            "create_date" : "",
            "modify_user" : "",
            "modify_date" : "",
            "ref_qc_plan_line_id" : "",
            "sampling_qty" : "",
            "item_barcode" : "",
            "retail_price" : "",
            "currency" : "",
            "style_size" : "",
            "substr_style_size" : ""
        ],
        "task_inspect_field_value_list": [
            "value_id" : "",
            "task_id" : "",
            "ref_value_id" : "",
            "inspect_field_id" : "",
            "field_value" : "",
            "create_date" : "",
            "create_user" : "",
            "modify_date" : "",
            "modify_user" : ""
        ],
        "task_inspect_data_record_list": [
            "record_id" : "",
            "task_id" : "",
            "ref_record_id" : "",
            "inspect_section_id" : "",
            "inspect_element_id" : "",
            "inspect_position_id" : "",
            "inspect_position_zone_value_id" : "",
            "inspect_position_desc" : "",
            "request_section_id" : "",
            "request_element_desc" : "",
            "inspect_detail" : "",
            "inspect_remarks" : "",
            "result_value_id" : "",
            "create_date" : "",
            "create_user" : "",
            "modify_date" : "",
            "modify_user" : ""
        ],
        "task_inspect_position_point_list": [
            "inspect_record_id" : "",
            "inspect_position_id" : "",
            "create_date" : "",
            "create_user" : "",
            "modify_date" : "",
            "modify_user" : ""
        ],
        "task_defect_data_record_list": [
            "record_id" : "",
            "task_id" : "",
            "inspect_record_id" : "",
            "ref_record_id" : "",
            "inspect_element_id" : "",
            "inspect_element_defect_value_id" : "",
            "inspect_element_case_value_id" : "",
            "defect_desc" : "",
            "defect_remarks_option_list" : "",
            "other_remarks" : "",
            "defect_qty_critical" : "",
            "defect_qty_major" : "",
            "defect_qty_minor" : "",
            "defect_qty_total" : "",
            "create_date" : "",
            "create_user" : "",
            "modify_date" : "",
            "modify_user" : ""
        ],
        "task_inspect_photo_file_list": [
            "photo_id" : "",
            "task_id" : "",
            "ref_photo_id" : "",
            "org_filename" : "",
            "photo_file" : "",
            "thumb_file" : "",
            "photo_desc" : "",
            "data_type" : "",
            "data_record_id" : "",
            "create_date" : "",
            "create_user" : "",
            "modify_date" : "",
            "modify_user" : ""
        ],
        "task_status_list": [
            "task_id":"",
            "ref_task_id":"", //add 0424 2019
            "task_status":"",
            "data_refuse_desc":"" //add 1107
        ]
    ]
] as [String : Any]

//Task Photo Data Upload
let _DS_ULTASKPHOTO = [
    "NAME" : "Task Photo Data Upload",
    "APINAME" : "\(dataSyncServerUsing)ul_task_photo.aspx",
    "APIPARA" : [
        "service_token": _DS_SERVICETOKEN,
        "device_id": UIDevice.current.identifierForVendor!.uuidString,
        "service_type": "Task Photo Data Upload",
        "task_id": "task_id",
        "photo_id" : "photo_id",
        "photo_file" : "photo_file",
        "photo_file_data" : "photo_file",
        "thumb_file": "thumb_file",
        "thumb_file_data": "thumb_file",
        "ref_task_id": "ref_task_id"
    ],
    "ACTIONNAMES" : [
        "novalue"
    ],
    "ACTIONTABLES" : [
        "novalue"
    ],
    "ACTIONFIELDS" : [
        "nokey" : [
            "novalue"
        ]
    ]
] as [String : Any]


