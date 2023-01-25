<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="EditPatientBill_Detail.aspx.cs" Inherits="Design_EDP_EditPatientBill_Detail" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Lab</title>
        <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />

         
</head>
       
<body style="font-size: 10pt">
    <form id="form1" runat="server">
       <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
       <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
       <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
       <script type="text/javascript" src="../../Scripts/Message.js"></script>
       <script type="text/javascript" >
          
           $(function () {
               var TID = "<%=Util.GetString(Request.QueryString["TID"])%>";
               bindPrescribedItem()
               bindMedicalItem()
           });
           function searchDetail() {
               $('#btnGetPresItem').hide();
               if (jQuery.trim($("#txtIPDNo").val()) != "") {
                   $.ajax({
                       url: "EditPatientBill_Detail.aspx/bindPatientData",
                       data: '{IPDNo:"' + + '"}',
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       async: false,
                       dataType: "json",
                       success: function (result) {
                           Isdischarge = (result.d);
                           if (Isdischarge == "1") {
                               jQuery("#spnErrorMsg").text('Please First Discharge Patient ');
                               jQuery('#div_PatientDetail,#div_Medicine').hide();
                           }
                           else if (Isdischarge == "3") {
                               jQuery("#spnErrorMsg").text('Patient Admission Is Cancel');
                               jQuery('#div_PatientDetail,#div_Medicine').hide();
                           }
                           else {
                               jQuery("#spnErrorMsg").text('');
                               bindPatientDetail();
                           }
                       },
                       error: function (xhr, status) {
                           $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                       }
                   });
               }
               else {
                   jQuery("#spnErrorMsg").text('Please Enter IPD No.');
                   jQuery("#txtIPDNo").focus();
               }
           }
           function bindPatientDetail() {

               $.ajax({
                   url: "EditPatientBill_Detail.aspx/bindPatientDetail",
                   data: '{IPDNo:"' + $.trim($("#txtIPDNo").val()) + '"}',
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   timeout: 120000,
                   async: false,
                   dataType: "json",
                   success: function (result) {
                       patientData = jQuery.parseJSON(result.d);
                       if (patientData != null) {
                           jQuery('#spnPatientID').text(patientData[0]["PatientID"]);
                           jQuery('#spnIPDNo').text(patientData[0]["IPDNo"]);
                           jQuery('#spnPatientName').text(patientData[0]["PName"]);
                           jQuery('#spnPanel').text(patientData[0]["Company_Name"]);
                           jQuery('#spnTransactionID').text(patientData[0]["TransactionID"]);
                           jQuery('#div_Medicine,#div_PatientDetail').show();
                           bindPrescribedItem();
                           bindMedicalItem();
                       }
                       else {
                           jQuery('#spnPatientID').text(patientData[0]["PatientID"]);
                           jQuery('#spnIPDNo').text(patientData[0]["IPDNo"]);
                           jQuery('#spnPatientName').text(patientData[0]["PName"]);
                           jQuery('#spnPanel').text(patientData[0]["PanelName"]);
                           jQuery('#div_Medicine').show();
                           $('#spnPreitem,#ddlPrescribeItem').hide();
                           bindMedicalItem();
                       }
                   }
               });
           }

           function bindPrescribedItem() {
               var TID = '<%=Util.GetString(Request.QueryString["TransactionID"])%>';
            jQuery("#ddlPrescribeItem option").remove();
            $.ajax({
                url: "EditPatientBill_Detail.aspx/bindPrescribedItem",
                data: '{IPDNo:"' + TID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null && data != "") {
                        var data = jQuery.parseJSON(mydata.d);
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlPrescribeItem').append($("<option></option>").val(data[i].itemID).html(data[i].itemName));
                        }
                    }
                    else {
                        bindMedicalItem();
                    }
                }
            });
        }
        function bindMedicalItem() {
            jQuery("#ddlReplaceItem option").remove();
            $.ajax({
                url: "EditPatientBill_Detail.aspx/bindMedicalItem",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null || data != "") {
                        jQuery("#ddlReplaceItem").append(jQuery("<option></option>").val('0').html("Select"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlReplaceItem').append($("<option></option>").val(data[i].ItemID).html(data[i].TypeName));
                        }
                    }
                    else {
                        jQuery("#ddlReplaceItem").append(jQuery("<option></option>").val('0').html("--No Stock--"));
                    }
                }
            });
        }
        function getItemDetail() {
            
               var TID = "<%=Util.GetString(Request.QueryString["TransactionID"])%>";
            $('#spnErrorMsg').text('');
            if ($("#ddlPrescribeItem").val() != null) {
                $.ajax({
                    url: "EditPatientBill_Detail.aspx/bindGetItemDetail",
                    data: '{IPDNo:"' + TID + '",From:"' + $('#txtpreFromDate').val() + '",To:"' + $('#txtpreToDate').val() + '" , ItemID:"' + $("#ddlPrescribeItem").val().split('#')[0] + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != null) {
                            var output = jQuery('#tb_PatientLabSearch').parseTemplate(PatientData);
                            jQuery('#PatientPreItemOutput').html(output);
                            jQuery('#PatientPreItemOutput,#divPatientPreItemOutput').show();
                            $('#chkIsReplace').attr('checked', true);
                            if ($("#rdoReplace").is(':checked'))
                                $("#btnReplaceitem,#divMedicine").show();
                            else
                                $("#btnReplaceitem,#divMedicine").hide();
                        }
                        else {
                            $('#PatientPreItemOutput,#divPatientPreItemOutput,#divMedicine').hide();
                            $('#PatientPreItemOutput').clearQueue();
                            $('#spnErrorMsg').text('No Data Found');
                        }

                    }
                });
            }

            else {
                $('#spnErrorMsg').text('No Data Found');
            }
        }
        </script>
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                $("#spnErrorMsg").text('Enter Numeric Value Only');
                return false;

            }
            else {
                $("#spnErrorMsg").text(' ');
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            $("#spnErrorMsg").text('Only One Decimal Allow');
                        return false;
                    }
                }
            }
            else {
                $("#spnErrorMsg").text(' ');
            }
        }
        function ckhall() {
            if ($("#chkHeader").attr('checked')) {
                $("#tb_Medicine :checkbox").attr('checked', 'checked');
            }
            else {
                $("#tb_Medicine :checkbox").attr('checked', false);
            }
        }
        function ShowStock() {
            jQuery("#ddlStock option").remove();
            $.ajax({
                url: "EditPatientBill_Detail.aspx/ShowStock",
                data: '{itemID:"' + $("#ddlReplaceItem").val().split('#')[0] + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    data = jQuery.parseJSON(result.d);
                    if (data != null && data != "") {
                        jQuery("#ddlStock").append(jQuery("<option></option>").val('0').html("Select"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlStock').append($("<option></option>").val(data[i].StockID).html(data[i].ItemName));
                        }
                    }
                    else {
                        $('#ddlStock').append($("<option></option>").val('0').html("--No Stock--"));
                    }
                }
            });
        }
        function CheckRate() {
            jQuery('#spnMedicineRate').text('');
            $.ajax({
                url: "EditPatientBill_Detail.aspx/CheckRate",
                data: '{StockID:"' + $("#ddlStock").val().split('#')[1] + '", ItemID:"' + $("#ddlStock").val().split('#')[0] + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Rate = jQuery.parseJSON(result.d);
                    if (Rate != null) {
                        jQuery('#spnMedicineRate').text(Rate[0]["Mrp"]);
                        jQuery('#spnDisRate,#spnMedicineRate,#btnReplaceitem').show();
                        if($("#tb_Medicine tr").length>0)
                            jQuery('#btnReplaceitem').show();
                        else
                            jQuery('#btnReplaceitem').hide();
                    }
                    else {
                        jQuery('#spnMedicineRate').text('');
                        jQuery('#spnDisRate,#btnReplaceitem').hide();
                    }


                }
            });
        }
        </script>
    <script type="text/javascript">

        function LedgerTransactionDetail() {
            var dataLTDt = new Array();
            var ObjLdgTnxDt = new Object();
            var j = 0;
            $('#tb_Medicine tr').each(function () {
                var id = $(this).attr("id");
                var $rowID = $(this).closest("tr");
                if (id != 'Tr1') {
                    if ($(this).find("#chkIsReplace").is(":checked")) {
                        if (($.trim( $(this).find("#txtReplace").val()) != "") && ($.trim($(this).find("#txtReplace").val()) != "0")) {
                            ObjLdgTnxDt.LedgerTnxId = jQuery.trim($rowID.find("#tdLedgerTnxId").text());
                            ObjLdgTnxDt.OldStockID = jQuery.trim($rowID.find("#tdStockID").text());
                            ObjLdgTnxDt.OldItemID = jQuery.trim($rowID.find("#tditemID").text());
                            ObjLdgTnxDt.ItemID = $("#ddlReplaceItem").val().split('#')[0];
                            ObjLdgTnxDt.ItemName = $("#ddlReplaceItem option:selected").html();
                            ObjLdgTnxDt.Rate = jQuery.trim($("#spnMedicineRate").text());
                            ObjLdgTnxDt.Quantity = jQuery.trim($rowID.find("#txtReplace").val());
                            ObjLdgTnxDt.Amount = jQuery.trim($rowID.find("#txtReplace").val()) * jQuery.trim($("#spnMedicineRate").text());
                            ObjLdgTnxDt.StockID = $("#ddlStock").val().split('#')[1];
                            ObjLdgTnxDt.SubCategoryID = $("#ddlReplaceItem").val().split('#')[1];
                            ObjLdgTnxDt.LedgertransactionNo = jQuery.trim($rowID.find("#tdLedgerTransactionNo").text());
                            ObjLdgTnxDt.DiscountPrecentage = 0.00;
                            ObjLdgTnxDt.DisAmount = 0.00;
                            ObjLdgTnxDt.afterbill = 1;
                            dataLTDt.push(ObjLdgTnxDt);
                            ObjLdgTnxDt = new Object();
                            j++;
                        }
                    }
                }
            });
            if (j > 0)
                return dataLTDt;
            else
                return 0;
        }

        </script>
    <script type="text/javascript">
        function InsertMedicine() {
            var Dataledgertnx = new Array();
            var objLedgerTnx = new Object();
            $('#tbSelected tr').each(function () {
                var id = $(this).attr("id");
                var $rowID = $(this).closest("tr");
                if (id != 'trMedicine') {
                    objLedgerTnx.ItemID = jQuery.trim($rowID.find("#spnRepitemID").text());
                    objLedgerTnx.ItemName = jQuery.trim($rowID.find("#spnItemName").text());
                    objLedgerTnx.PDate = jQuery.trim($rowID.find("#PDate").text());
                    objLedgerTnx.BatchNumber = jQuery.trim($rowID.find("#bt").text());
                    objLedgerTnx.AddQty = jQuery.trim($rowID.find("#txtAddQty").val());
                    objLedgerTnx.MRP = jQuery.trim($rowID.find("#tdMRP").text());
                    objLedgerTnx.Unit = jQuery.trim($rowID.find("#tdUnit").text());
                    objLedgerTnx.Amount = jQuery.trim($rowID.find("#spnAmount").text());
                    objLedgerTnx.StockId = jQuery.trim($rowID.find("#spnStockID").text());
                    objLedgerTnx.SubCategoryID = $("#ddlReplaceItem").val().split('#')[1];
                    Dataledgertnx.push(objLedgerTnx);
                    objLedgerTnx = new Object();

                }
            });
            return Dataledgertnx;
        }
    </script>
    <script type="text/javascript">

        function SaveMedicine() {
            jQuery("#btnSaveMedicine").attr('disabled', 'disabled').val("Save...");
            var TID = "<%=Util.GetString(Request.QueryString["TransactionID"])%>";
            jQuery("#BtnSaveMedi").attr('disabled', 'disabled').val("Save...");
            var resultSveMed = InsertMedicine();
            if (resultSveMed.length > 0) {
                jQuery.ajax({
                    url: "EditPatientBill_Detail.aspx/SaveMedical",
                    data: JSON.stringify({ SMedicine: resultSveMed, tid: TID, pid: $("#spnPatientID").text(), PanelID: $("#spnPanelID").text() }),
                    type: "Post",
                    contentType: "application/json;charset=utf-8",
                    timeout: "120000",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            DisplayMsg('MM01', 'spnErrorMsg');
                            ClearSaveMedicine();
                            jQuery("#btnSaveMedicine").attr('disabled', false).val("Save");

                        }

                        else {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                    }
                });

            }
        }


    </script>
    <script type="text/javascript">
        function replaceMedicine() {
            $("#spnErrorMsg").text('');
            if ($("#ddlReplaceItem").val().split('#')[0] == "0") {
                $("#spnErrorMsg").text('Please Select Item');
                $("#ddlReplaceItem").focus();
                return;
            }
            if ($("#ddlStock").val() == "0") {
                $("#spnErrorMsg").text('Please Select Stock');
                $("#ddlStock").focus();
                return;

            }
            jQuery("#btnReplaceitem").attr('disabled', 'disabled').val("Updating...");
           
            var resultLTD = LedgerTransactionDetail();
            if (resultLTD!="0") {
                jQuery.ajax({
                    url: "EditPatientBill_Detail.aspx/UpdateMedicalBill",
                    data: JSON.stringify({ LTDData: resultLTD }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            DisplayMsg('MM01', 'spnErrorMsg');
                            Clear();
                            bindPrescribedItem();
                            bindMedicalItem();
                            CheckRate();
                            jQuery("#btnReplaceitem").attr('disabled', false).val("Update");
                        }
                        else {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        jQuery("#btnReplaceitem").attr('disabled', false).val("Update");
                        DisplayMsg('MM05', 'spnErrorMsg');
                    }
                });
            }
            else {
                $('#spnErrorMsg').text('Please Enter Replace Qty. OR Select Proper Data');
                jQuery("#btnReplaceitem").attr('disabled', false).val("Update");
            }
        }

        function Clear() {
            $("#tb_Medicine tr").remove();
            $("#tb_Medicine,#btnReplaceitem,#spnDisRate.#divMedicine,#divPatientPreItemOutput,#divtbSelected").hide();
            $('#ddlPrescribeItem,#ddlReplaceItem,#ddlStock').prop('selectedIndex', 0);
            $("#spnMedicineRate").val('').hide();           
        }
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtpreFromDate').val() + '",DateTo:"' + $('#txtpreToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#spnErrorMsg').text('To date can not be less than from date!');
                        $('#btnGetPresItem,#btnAddWithReplace').attr('disabled', 'disabled');
                    }
                    else {
                        $('#spnErrorMsg').text('');
                        $('#btnGetPresItem,#btnAddWithReplace').removeAttr('disabled');
                    }
                }
            });

        }
        </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">          
                <b>Edit Patient Bill</b>
                <br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>            
        </div>
        
         <div class="POuter_Box_Inventory" style="text-align: center;display:none">      
            <table style="width:100%; display:none">
                <tr>
                    <td style="width:20%;text-align:right">
                        IPD No. :&nbsp;
                    </td>
                    <td style="width: 178px">
                        <asp:TextBox ID="txtIPDNo" AutoCompleteType="Disabled" runat="server" MaxLength="10" ClientIDMode="Static"></asp:TextBox>
                          <span style="color: red; font-size: 10px;"  class="shat">*</span>
                        
                    </td>
                    <td>
 <input type="button" class="ItDoseButton" id="btnSearch" value="Search"   onclick="searchDetail()" />
                    </td>
                    <td>

                    </td>
                </tr>
            </table>
            </div>      
         <div  id="div_PatientDetail" style="display:none">
             <div class="Purchaseheader" style="display:none">
                 Patient Detail
             </div>
              <asp:Panel ID="pnlPatientDetail" runat="server"    >         
                <table  style=" width:100%; display:none" id="tb_PatientDetail"  >
                    <tr>
                        <td style="text-align:right;width:20%">
                            UHID :&nbsp;
                        </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnPatientID" class="ItDoseLabelSp"></span>
                             
                        </td>
                        <td style="text-align:right;width:20%">
                            IPD No. :&nbsp;
                            </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnIPDNo" class="ItDoseLabelSp"></span>
                            <span id="spnTransactionID" class="ItDoseLabelSp" style="display:none;"></span>
                            <span id="spnUniqueHash" class="ItDoseLabelSp" style="display:none;"></span>
                        </td>
                    </tr>
                    <tr>
                         <td style="text-align:right;width:20%">
                            Name :&nbsp;
                        </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnPatientName" class="ItDoseLabelSp"></span>
                            
                        </td>
                         <td style="text-align:right;width:20%">
                            Panel :&nbsp;
                            </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnPanel" class="ItDoseLabelSp"></span>
                            <span id="spnPanelID" class="ItDoseLabelSp" style="display:none"></span>
                            
                        </td>
                    </tr>
                     
                    
                   
        </table>
                  </asp:Panel>
        </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">          

            <div  id="div_Medicine">
                <div class="Purchaseheader">
                    Medicine Detail
                </div>
                <table  id="tb_Replace" style="border-collapse:collapse;width:100%" >
                    <tr>
                        <td> 
                   <table style="border-collapse:collapse;width:100%" >
                   <tr>
    <td style="text-align:right; width: 14%;">
        <span id="spnPreitem"> Prescribe&nbsp;Item&nbsp;:&nbsp;</span>

    </td>
    <td style="text-align:left;width:36%">
        <select id="ddlPrescribeItem" style="width:300px" ></select>
     </td>
   
    <td style="text-align:right; width: 14%;">
        Replace&nbsp;Item&nbsp;:&nbsp;          
    </td><td style="text-align:left;width:36%">
        <select id="ddlReplaceItem" style="width:300px" onchange="ShowStock();"></select>    
        <span style="color: red; font-size: 10px;"  class="shat" id="spnReplaceItem">*</span>                
         </td>
</tr>   
                       </table>
                        <table style="border-collapse:collapse;width:100%" >             
                   <tr>
                        <td style="text-align:right; width: 14%;">
                            &nbsp;
                        </td>
                        <td style="text-align:left;width:36%">
                             &nbsp;
                             </td>

    
                       <td style="text-align:right; width: 14%;">
                            <span id="spnQty" style="display:none">Qty.&nbsp;:&nbsp;</span> 
                            </td>
                       <td style="text-align:left;width:36%">
                            
                           <asp:TextBox ID="qtyAll" style="display:none" runat="server" ClientIDMode="Static" Width="40px"></asp:TextBox>
                           <span style="color: red; font-size: 10px;display:none"  class="shat" id="spnQtyDot">*</span>
                           <cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" TargetControlID="qtyAll"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </td>
                    </tr>
                       </table>
                        <table style="border-collapse:collapse;width:100%" >         
                   <tr>
                       <td style="text-align:right; width: 14%;">
                           From&nbsp;Pres.&nbsp;Date&nbsp;:&nbsp;

                       </td>
                       <td style="text-align:left;width:36%">
                           <asp:TextBox ID="txtpreFromDate" runat="server" Width="100px" ClientIDMode="Static" ></asp:TextBox>
                           <span style="color: red; font-size: 10px;"  class="shat">*</span>
                           <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtpreFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>

                       </td>
                       
                       <td style="text-align:right; width: 14%;">
                            <span id="spnStocks" >Stocks&nbsp;:&nbsp;</span></td>
                     <td style="text-align:left;width:36%">
                                <select id="ddlStock" style="width:300px;" onchange="CheckRate()"></select>
                                 <span style="color: red; font-size: 10px;"  class="shat" id="spnStock">*</span>                

                       </td>

                   </tr>   
                     </table>
                             <table style="border-collapse:collapse;width:100%" >                        
                   <tr>
                    <td style="text-align:right; width: 14%;">To&nbsp;Pres.&nbsp;Date&nbsp;:&nbsp;</td>                                  
                       <td style="text-align:left;width:36%">
                           <asp:TextBox ID="txtpreToDate"  Width="100px" runat="server" ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                           <span style="color: red; font-size: 10px;"  class="shat">*</span>
                           <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtpreToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender></td>
                       
                        <td style="width: 14%;text-align:right">                                                                                                                                                                       
                         <span id="spnDisRate" class="ItDoseLabelSp" style="display:none">Rate&nbsp;:&nbsp;</span>
                           </td>                      
                        <td style="text-align:left;width:36%">
                            <span id="spnMedicineRate" class="ItDoseLabelSp"></span></td>
                        </tr>
                            </table>
                             <table style="border-collapse:collapse;width:100%" >               
                            <tr>
                               <td style="text-align:right; width: 14%;">
                                   &nbsp;
                                </td>
                                 <td style="text-align:left;width:36%">
                                      &nbsp;
                                </td>
                                
                       
                                 <td style="text-align:left;width:50%" colspan="2">
                                     <input  type="radio" name="Medicine"  onclick="medicineAdd()"/>Add
                                          
                                 <input type="radio" name="Medicine"  id="rdoReplace" checked="checked"  onclick="AddReplace()"/>Replace
                                        
                                 <input type="radio" name="Medicine"  onclick="addWithReplace()"/>AddWithReplace
                                   
                                     </td>
                            </tr>
                             </table>
                             
                       
                
                        </td>
                </tr>
                </table>
              </div>
                 </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="border-collapse:collapse;width:100%" >   
                   <tr><td style="width: 100%">
                            <input type="button" id="btnGetPresItem"  value="Get Prescribed Item" class="ItDoseButton" onclick="getItemDetail();"/>
                       
                           <input type="button" id="btnAddWithReplace" value="AddWithReplace" class="ItDoseButton" onclick="addWithReplaceMedicine()" style="display:none"/>

                            <input type="button" id="btnAdd" value="Add" class="ItDoseButton" onclick="addMedicine()" style="display:none"/>
                        </td>
                    </tr>
                             </table>
            </div>
          <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="divPatientPreItemOutput"> 
                 <table  style="width: 100%; border-collapse:collapse">
                <tr style="text-align:center">
                    <td colspan="4">
                        <div id="PatientPreItemOutput" style="display:none" >
                        </div>                     
                    </td>               
                </tr>                   
            </table>
               </div>

          <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="divtbSelected"> 
                            <table id="tbSelected"  rules="all" border="1" style="border-collapse: collapse; display:none" class="GridViewStyle">
                                <tr id="trMedicine">
            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">
            <input id="Checkbox1" type="checkbox"  onclick='ckhall();' /></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px; display:none">ItemId</th>                
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">P.Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Batch No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px; ">Quantity</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">MRP</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Unit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px">Remove</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none" >StockId</th>           
		</tr>
</table>
        
             </div>

        <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="divMedicine">                    
                        <input type="button" id="btnReplaceitem" value="Update" class="ItDoseButton" onclick="replaceMedicine()" style="display:none"/>                    
                        <input type="button" id="btnSaveMedicine" value="Save" class="ItDoseButton" onclick="SaveMedicine()" style="display:none"/>                                                                                 
        </div>       
       
        </div>
         <script id="tb_PatientLabSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_Medicine"
    style="width:940px;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;"><input id="chkHeader" type="checkbox"  onclick='ckhall();' /></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Sub Category</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Rate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Quantity</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:380px;display:none">Bill Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Replace Qty.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">P.Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">StockID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">ItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">LedgerNO</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">LedgerTnxID</th>           
		</tr>
        <#     
        var dataLength=PatientData.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];     
          #>
                    <tr id="<#=j+1#>" >
                        <td class="GridViewLabItemStyle" style="width: 10px;"><#=j+1#></td>
                        <td id="tdChk" class="GridViewItemStyle" style="width: 10px;"><input type="checkbox" id="chkIsReplace" checked="checked"/></td>
                        <td id="tdItemName" class="GridViewLabItemStyle" style="width: 260px;"><#=objRow.itemname#></td>
                        <td id="tdPanel" class="GridViewLabItemStyle" style="width: 150px;"><#=objRow.Name#></td>
                        <td id="tdRate" class="GridViewLabItemStyle" style="width: 60px;"><#=objRow.Rate#></td>
                        <td id="tdQuantity" class="GridViewLabItemStyle" style="width: 60px;"><#=objRow.Quantity#></td>
                        <td id="tdAmount" class="GridViewLabItemStyle" style="width: 60px;"><#=objRow.Amount#></td>
                        <td id="tdBillDate" class="GridViewLabItemStyle" style="width: 60px;display:none "><#=objRow.BillDate#></td>
                        <td id="tdReplaceQty" class="GridViewLabItemStyle" style="width: 60px;"><input id="txtReplace" type="text" maxlength="4" onkeypress="return checkForSecondDecimal(this,event)"  style="text-align:right;width:50%"/><span style="color: red; font-size: 10px;"  class="shat">*</span></td>
                        <td id="tdStockID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.StockID#></td>
                        <td id="tditemID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.itemID#></td>
                        <td id="tdLedgerTransactionNo" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.LedgerTransactionNo#></td>
                        <td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align:center; display:none"><#=objRow.TransactionID#></td>
                        <td id="tdLedgerTnxId" class="GridViewLabItemStyle" style="text-align:center; display:none"><#=objRow.LedgerTnxID#></td>
                        <td id="td1" class="GridViewLabItemStyle" style="width: 100px;"><#=objRow.PDate#></td>
                </tr>   

            <#}#>

     </table>    
    </script>
       <script type="text/javascript">
           function addWithReplace() {
               $("#btnAdd,#btnGetPresItem,#divPatientPreItemOutput,#divtbSelected,#divMedicine").hide();
               $("#btnAddWithReplace,#ddlPrescribeItem,#spnStocks,#ddlStock,#spnQty,#qtyAll,#spnQtyDot,#spnReplaceItem,#spnStock").show();
               $("#tbSelected tr:not(:first)").remove();
               $("#qtyAll").val('');
           }
           function addWithReplaceMedicine() {
               $("#spnErrorMsg").text('');
               if ($("#ddlReplaceItem").val().split('#')[0] == "0") {
                   $("#spnErrorMsg").text('Please Select Item');
                   $("#ddlReplaceItem").focus();
                   return;
               }
               if (($.trim($("#qtyAll").val()) == "") || ($.trim($("#qtyAll").val()) == "0")) {
                   $("#spnErrorMsg").text('Please Enter Qty.');
                   $("#qtyAll").focus();
                   return;
               }
               
               if ($("#ddlStock").val() == "0") {
                   $("#spnErrorMsg").text('Please Select Stock');
                   $("#ddlStock").focus();
                   return;
               }
               var TID = "<%=Util.GetString(Request.QueryString["TransactionID"])%>";
               jQuery("#btnAddWithReplace").attr('disabled', true).val("Submitting..."); 

               $.ajax({
                   url: " EditPatientBill_Detail.aspx/saveAddWithReplaceMedicine",
                   data: '{PItemID:"' + $("#ddlPrescribeItem").val().split('#')[0] + '" ,replaceItemName:"' + $("#ddlReplaceItem option:selected").text() + '", replaceItemID:"' + $("#ddlReplaceItem").val().split('#')[0] + '" ,FromDate:"' + $('#txtpreFromDate').val() + '",ToDate:"' + $('#txtpreToDate').val() + '",Qty:"' + $('#qtyAll').val() + '",stockID:"' + $("#ddlStock").val().split('#')[1] + '",TID:"' + TID + '",LedgerTransactionNo:"' + $("#ddlPrescribeItem").val().split('#')[1] + '"}',
                   type: "POST",
                   async: false,
                   dataType: "json",
                   contentType: "application/json; charset=utf-8",
                   success: function (result) {
                       AddRepMed = (result.d);
                       if (AddRepMed == "1") {
                           DisplayMsg('MM01', 'spnErrorMsg');
                           bindPrescribedItem();
                       }
                       else
                           DisplayMsg('MM05', 'spnErrorMsg');
                       jQuery("#btnAddWithReplace").attr('disabled', false).val("AddWithReplace");

                   },
                   error: function (xhr, status) {
                       DisplayMsg('MM05', 'spnErrorMsg');
                       jQuery("#btnAddWithReplace").attr('disabled', false).val("AddWithReplace");
                   }
               });
           }
       </script>
            <script type="text/javascript">
                function addMedicine() {
                    var ItemID = $("#ddlReplaceItem").val().split('#')[0];
                    
                    if (ItemID == "0") {
                        $("#spnErrorMsg").text('Please Select Item');
                        $("#ddlReplaceItem").focus();
                        return;
                    }
                    if (chkdupitem(ItemID)) {
                        $("#spnErrorMsg").text('Selected Item Already Added');
                        $("#ddlReplaceItem").focus();
                        return;
                    }
                    if ($('#qtyAll').val() == "") {
                        jQuery("#spnErrorMsg").text('Please Entry Qty.');
                        $('#qtyAll').focus();
                        return;
                    }

                    $('#btnSaveMedicine,#divMedicine').show();
                    $.ajax({
                        url: " EditPatientBill_Detail.aspx/bindAddMedicineDetail",
                        data: '{ItemID:"' + $("#ddlReplaceItem").val().split('#')[0] + '" ,From:"' + $('#txtpreFromDate').val() + '",To:"' + $('#txtpreToDate').val() + '",Qty:"' + $('#qtyAll').val() + '"}',
                        type: "POST",
                        async: false,
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (result) {
                            AddMeidicneData = jQuery.parseJSON(result.d);
                            if (AddMeidicneData.length > 0) {
                                for (var i = 0; i < AddMeidicneData.length; i++) {
                                    $('#tbSelected').css('display', 'block');
                                    $('#tbSelected').append('<tr><td id="tdChk" class="GridViewItemStyle" style="width: 10px;"><input type="checkbox" id="chkIsReplace" checked="checked"/></td><td id="tdIM"class="GridViewLabItemStyle"><span id="spnItemName">' + AddMeidicneData[i].ItemName + '</span><span id="spnRepitemID" style="display:none">' + AddMeidicneData[i].AITEMID + '</span> </td> <td id="idPDate" class="GridViewLabItemStyle"><span id="PDate">' + AddMeidicneData[i].PDate + '</span></td><td id="tdBatchNumber"class="GridViewLabItemStyle"> <span id="bt">' + AddMeidicneData[i].BatchNumber + '</span></td><td id="tdQty" class="GridViewLabItemStyle"><input type="text" id="txtAddQty" onkeyup="Rate(this);" style="width:30px" value=' + $('#qtyAll').val() + ' class="ItDoseTextinputNum" onkeypress="return checkNumericDecimal(event,this);" /> </td><td id="spnMRP" class="GridViewLabItemStyle"><span id="tdMRP">' + AddMeidicneData[i].MRP + '</span></td> <td class="GridViewLabItemStyle"><span id="tdUnit">' + AddMeidicneData[i].UnitType + '</span></td> <td id="tdAddAmount" class="GridViewLabItemStyle" style="width: 60px;"><span id="spnAmount">' + precise_round(parseFloat(AddMeidicneData[i].MRP * $('#qtyAll').val()), 2) + '</span></td> <td class="GridViewLabItemStyle" style=" display:none" > <span id="spnStockID">' + AddMeidicneData[i].StockID + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td> </tr>');

                                }
                                $('#divtbSelected').show();
                            }
                        }
                    });

                }
                function precise_round(num, decimals) {
                    return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
                }
                function RemoveRows(rowid) {
                    $(rowid).closest('tr').remove()
                    if ($('#tbSelected tr:not(#trMedicine)').length == 0) {
                        $('#divtbSelected').hide();
                    }

                }
                function chkdupitem(ItemID) {
                    var count = 0;
                    $('#tbSelected tr:not(#trMedicine)').each(function () {
                        if ($(this).find('#spnRepitemID').text().trim() == ItemID) {
                            count = count + 1;
                        }
                    });
                    if (count == 0)
                        return false;
                    else
                        return true;
                }

                function Rate(rowid) {
                    var qty = $(rowid).closest('tr').find("#txtAddQty").val();
                    var rate = $(rowid).closest('tr').find("#spnMRP").text();
                    ($(rowid).closest('tr').find("#spnAmount").text(parseFloat(qty * rate)));
                }
                function checkNumericDecimal(e, sender) {
                    var charCode = (e.which) ? e.which : e.keyCode;
                    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                        return false;
                    }
                    if (sender.value == "1") {
                        sender.value = sender.value.substring(0, sender.value.length - 1);
                    }
                }
                function medicineAdd() {
                    $('#btnAdd,#qtyAll,#spnQty,#spnQtyDot,#spnReplaceItem').show();
                    $('#ddlPrescribeItem,#btnAddWithReplace,#ddlStock,#btnReplaceitem,#btnGetPresItem,#spnStocks,#ddlStock,#divtbSelected,#spnDisRate,#spnMedicineRate,#divPatientPreItemOutput,#divMedicine,#spnStock').hide();
                    $("#tbSelected tr:not(:first)").remove();

                }
                function AddReplace() {
                    $('#ddlPrescribeItem,#ddlStock,#btnGetPresItem,#spnStocks,#ddlStock,#spnStock,#spnReplaceItem').show();
                    $('#tbSelected,#divtbSelected,#btnAddWithReplace,#qtyAll,#spnQty,#btnAdd,#btnSaveMedicine,#spnQtyDot').hide();
                }
                function ClearSaveMedicine() {
                    $("#tbSelected tr:not(:first)").remove();
                    $('#btnSaveMedicine').hide();
                    $('#tbSelected,#divtbSelected').hide();


                }
    </script>


        </form>
    </body>
    </html>


