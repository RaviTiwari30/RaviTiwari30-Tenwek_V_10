using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for CardClaimSubmitDetails
/// </summary> 
/// 



public class CardPatientDetails
{
    public string claim_code { get; set; }
    public string payer_code { get; set; }
    public string payer_name { get; set; }
    public string medicalaid_code { get; set; }
    public double amount { get; set; }
    public double gross_amount { get; set; }
    public string batch_number { get; set; }
    public string dispatch_date { get; set; }
    public string patient_number { get; set; }
    public string patient_name { get; set; }
    public string location_code { get; set; }
    public string location_name { get; set; }
    public string scheme_code { get; set; }
    public string scheme_name { get; set; }
    public string member_number { get; set; }
    public string visit_number { get; set; }
    public int session_id { get; set; }
    public string visit_start { get; set; }
    public string visit_end { get; set; }
    public string currency { get; set; }
    public string doctor_name { get; set; }
    public int sp_id { get; set; }

}


public class CardDiagnosis
{
    public string code { get; set; }
    public string coding_standard { get; set; }
    public bool is_added_with_claim { get; set; }
    public string name { get; set; }
    public bool primary { get; set; }
}

public class CardPreAuthorization
{
    public string code { get; set; }
    public double amount { get; set; }
    public string authorized_by { get; set; }
    public string message { get; set; }

}
public class CardAdmissionDetails
{
    public string additional_info { get; set; }
    public string admission_date { get; set; }
    public string admission_number { get; set; }
    public string discharge_date { get; set; }
    public string discharge_summary { get; set; }

}


public class CardInvoiceDetails
{
    public double amount { get; set; }
    public double gross_amount { get; set; }
    public string invoice_date { get; set; }
    public string invoice_number { get; set; }
    public string invoice_ref_number { get; set; }
    public string pool_number { get; set; }
    public string service_type { get; set; }
    public List<CardInvoiceLinesDetails> lines { get; set; }
    public List<CardInvoicePaymentModifiersDetails> payment_modifiers { get; set; }


}

public class CardInvoiceLinesDetails
{
    public string additional_info { get; set; }
    public double amount { get; set; }
    public string charge_date { get; set; }
    public string invoice_number { get; set; }
    public string charge_time { get; set; }
    public string item_code { get; set; }
    public string item_name { get; set; }

    public string pre_authorization_code { get; set; }
    public double quantity { get; set; }
    public string service_group { get; set; }
    public double unit_price { get; set; }

}

public class CardInvoicePaymentModifiersDetails
{
    public string type { get; set; }
    public double amount { get; set; }
    public string reference_number { get; set; }

    public string nhif_contributor_nr { get; set; }
    public string nhif_employer_code { get; set; }
    public string nhif_member_nr { get; set; }
    public string nhif_patient_relation { get; set; }
    public string nhif_site_nr { get; set; }

}


public class CardSubmitDetails
{
    public string code { get; set; }
    public string message { get; set; }
      public CardSubmitContentDetails content { get; set; }
}
public class CardSubmitContentDetails
{
    public int id { get; set; }
    public string message { get; set; }
}
 