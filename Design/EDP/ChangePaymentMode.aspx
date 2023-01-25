<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangePaymentMode.aspx.cs" Inherits="Design_EDP_ChangePaymentMode" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>

    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <b>Change Payment Mode</b>
            <br />
            
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 20%">Receipt No. :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtReceiptNo" runat="server" MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                        <span style="color: red; font-size: 10px;"  class="shat">*</span>
                    </td>
                    <td style="text-align: right; width: 20%">&nbsp;
                    </td>
                    <td style="text-align: right; width: 30%">&nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
           
            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" onclick="search()" />
        </div>
       
                <div class="POuter_Box_Inventory" style="text-align: center">
          <table  style="width: 100%;border-collapse:collapse" >
                <tr >
                    <td colspan="4">
                         <div id="PaymentOutput" style="max-height: 400px; overflow-x: auto;">
                        </div>
                        <br />                       
                    </td>
                </tr>
            </table>
        </div>
           
        
         <div class="POuter_Box_Inventory paymentModeDetail" style="text-align: center;display:none"  >
              <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 20%">Payment Mode :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                      <asp:DropDownList ID="ddlPaymentMode" runat="server" Width="140px" ClientIDMode="Static" onchange="showBankDetail()"></asp:DropDownList>
                    </td>
                    <td style="text-align: right; width: 20%">&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <span id="spnReceiptNo" style="display:none"></span>
                        <span id="spnOldPaymentModeID" style="display:none"></span>
                        <span id="spnOldPaymentMode" style="display:none"></span>
                        <span id="spnOldBankName" style="display:none"></span>
                        <span id="spnOldRefNo" style="display:none"></span>                                                                    
                        <span id="spnReceiptID" style="display:none"></span>
                        <span id="spnLedgerTransactionNo" style="display:none"></span>
                        <span id="spnLedgerNoDr" style="display:none"></span>
                        <span id="spnAmount" style="display:none"></span>
                    </td>
                </tr>
                  <tr style="display:none" id="tr_Mode">
                    <td style="text-align: right; width: 20%">Bank Name :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                      <asp:DropDownList ID="ddlBankName" runat="server" Width="140px" ClientIDMode="Static"></asp:DropDownList>
                        <span style="color: red; font-size: 10px;"  class="shat">*</span>
                    </td>
                    <td style="text-align: right; width: 20%">
                        Card&nbsp;/&nbsp;Ref.&nbsp;No.&nbsp;:&nbsp;
                        
                    </td>
                    <td style="text-align: left; width: 30%">
                        
                        <asp:TextBox ID="txtRefNo" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" MaxLength="50" Width="145px"></asp:TextBox>&nbsp;
                        <span style="color: red; font-size: 10px;"  class="shat">*</span>
                    <cc1:filteredtextboxextender ID="ftbtrefNo" runat="server" TargetControlID="txtrefNo"
                        FilterType="Numbers">
                    </cc1:filteredtextboxextender>
                    </td>
                </tr>
            </table>
         </div>
             
        <div class="POuter_Box_Inventory paymentModeDetail" style="text-align: center;display:none">
            
            <input type="button" id="btnSave" class="ItDoseButton"  value="Save" onclick="savePaymentMode()" />
         </div>
             
    </div>
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#txtReceiptNo").focus();
        });
    </script>

    <script id="tb_Payment" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdPayment"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Receipt No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Receipt Date Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Payment Mode</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Bank Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Ref No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>
           
                   
		</tr>
        <#       
        var dataLength=Payment.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = Payment[j];
        #>
                     <tr id="<#=j+1#>">                   
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdReceiptNo"  style="width:140px;text-align:center" ><#=objRow.ReceiptNo#></td>
                    <td class="GridViewLabItemStyle" id="tdRecDateTime"  style="width:160px;" ><#=objRow.RecDateTime#></td>
                    <td class="GridViewLabItemStyle" id="tdPaymentMode" style="width:160px;"><#=objRow.PaymentMode#></td>

                    <td class="GridViewLabItemStyle" id="tdS_Amount" style="width:100px;"><#=objRow.S_Amount#></td>
                    <td class="GridViewLabItemStyle" id="tdBankName" style="width:160px;"><#=objRow.BankName#></td>                 
                    <td class="GridViewLabItemStyle" id="tdRefNo" style="width:120px;"><#=objRow.RefNo#></td>     
                    <td class="GridViewLabItemStyle" id="tdPaymentModeID" style="width:60px;display:none"><#=objRow.PaymentModeID#></td>        
                    <td class="GridViewLabItemStyle" id="tdLedgertransactionNo" style="width:60px;display:none"><#=objRow.AsainstLedgerTnxNo#></td>    
                    <td class="GridViewLabItemStyle" id="tdLedgerNoDr" style="width:60px;display:none"><#=objRow.LedgerNoDr#></td>   
                             
                         <td class="GridViewLabItemStyle" id="tdReceiptID" style="width:60px;display:none"><#=objRow.ReceiptID#></td>                 
                     <td class="GridViewLabItemStyle" style="width:30px; text-align:center"  >                           
                       <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;cursor:pointer" onclick="bindPaymentMode(this)" />                                                                                           
                    </td>                                  
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>
    <script type="text/javascript">
        function search() {
            jQuery("#spnErrorMsg").text('');
            if (jQuery.trim(jQuery("#txtReceiptNo").val()) == "") {
                jQuery("#spnErrorMsg").text('Please Enter Receipt No.');
                jQuery("#txtReceiptNo").focus();
                return false;
            }
            jQuery("#btnSearch").val('Searching....').attr("disabled", "disabled");
            jQuery.ajax({
                type: "POST",
                url: "ChangePaymentMode.aspx/PaymentSearch",
                data: '{ReceiptNo:"' + jQuery.trim(jQuery("#<%=txtReceiptNo.ClientID%>").val()) + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    Payment = jQuery.parseJSON(response.d);
                    if (Payment != null) {
                        var output = jQuery('#tb_Payment').parseTemplate(Payment);
                        jQuery('#PaymentOutput').html(output);
                        jQuery('#PaymentOutput,.paymentDetail').show();
                        jQuery("#btnSearch").removeAttr("disabled");
                        
                    }
                    else {
                        jQuery('#PaymentOutput,.paymentDetail').hide();                       
                        jQuery("#spnErrorMsg").text('No Record Found');
                    }
                    jQuery('.paymentModeDetail').hide();
                    jQuery("#btnSearch").val('Search').removeAttr("disabled");
                },
                error: function (xhr, status) {
                    jQuery("#btnSearch").val('Search').removeAttr("disabled");
                }
            });
        }
         </script>
    <script type="text/javascript">
        function bindPaymentMode(rowID) {
            jQuery("#spnReceiptNo,#spnOldPaymentModeID,#spnOldBankName,#spnOldRefNo,#spnReceiptID,#spnOldPaymentMode,#spnLedgerTransactionNo,#spnLedgerNoDr,#spnAmount").text('');
            var PaymentModeID = jQuery(rowID).closest("tr").find('#tdPaymentModeID').text();
            jQuery("#spnReceiptNo").text(jQuery(rowID).closest("tr").find('#tdReceiptNo').text());
            jQuery("#spnOldPaymentModeID").text(jQuery(rowID).closest("tr").find('#tdPaymentModeID').text());
            jQuery("#spnOldPaymentMode").text(jQuery(rowID).closest("tr").find('#tdPaymentMode').text());
            
            jQuery("#spnOldBankName").text(jQuery(rowID).closest("tr").find('#tdBankName').text());
            jQuery("#spnOldRefNo").text(jQuery(rowID).closest("tr").find('#tdRefNo').text());
            jQuery("#spnReceiptID").text(jQuery(rowID).closest("tr").find('#tdReceiptID').text());
            jQuery("#spnLedgerTransactionNo").text(jQuery(rowID).closest("tr").find('#tdLedgertransactionNo').text());
            jQuery("#spnLedgerNoDr").text(jQuery(rowID).closest("tr").find('#tdLedgerNoDr').text());
            jQuery("#spnAmount").text(jQuery(rowID).closest("tr").find('#tdS_Amount').text());
            jQuery("#ddlPaymentMode option").remove();
            jQuery.ajax({
                url: "ChangePaymentMode.aspx/bindPaymentMode",
                data: '{PaymentModeID:"' + PaymentModeID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    PaymentMode = jQuery.parseJSON(result.d);
                    if (PaymentMode.length == 0) {
                        jQuery("#ddlPaymentMode").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < PaymentMode.length; i++) {
                            jQuery("#ddlPaymentMode").append(jQuery("<option></option>").val(PaymentMode[i].PaymentModeID).html(PaymentMode[i].PaymentMode));
                        }
                        jQuery(".paymentModeDetail").show();
                        showBankDetail();
                    }
                },
                error: function (xhr, status) {                    
                    jQuery("#ddlPaymentMode").attr("disabled", false);
                }
            });

        }
        function showBankDetail() {
            if (jQuery("#ddlPaymentMode").val() != "1")
                jQuery("#tr_Mode").show();
            else
                jQuery("#tr_Mode").hide();
            jQuery('#ddlBankName').prop("selectedIndex", 0);
            jQuery('#txtRefNo').val('');
        }
    </script>
    
    <script type="text/javascript">
        function savePaymentMode() {
            if (jQuery('#ddlPaymentMode').val() != "1") {
                if ((jQuery.trim(jQuery('#ddlBankName').val()) == "")) {
                    jQuery("#spnErrorMsg").text('Please Select Bank');
                    jQuery('#ddlBankName').focus();
                    return false;
                }
                if ((jQuery.trim(jQuery('#txtRefNo').val()) == "")) {
                    jQuery("#spnErrorMsg").text('Please Enter Ref No.');
                    jQuery('#txtRefNo').focus();
                    return false;
                }
            }
            jQuery("#btnSave").val('Submitting....').attr("disabled", "disabled");
             var newBankName = ""; var newRefNo = "";
            var newPaymentModeID = jQuery('#ddlPaymentMode').val();
            var newPaymentMode = jQuery('#ddlPaymentMode option:selected').text();
            if (jQuery('#ddlPaymentMode').val() != "1") {
                newBankName=jQuery('#ddlBankName option:selected').text();
                newRefNo = jQuery('#txtRefNo').val();
            }

            jQuery.ajax({
                url: "ChangePaymentMode.aspx/SavePaymentMode",
                data: '{ReceiptID:"' + jQuery("#spnReceiptID").text() + '",ReceiptNo:"' + jQuery("#spnReceiptNo").text() + '",newPaymentModeID:"' + newPaymentModeID + '",newPaymentMode:"' + newPaymentMode + '" ,newBankName:"' + newBankName + '" ,newRefNo:"' + newRefNo + '" ,oldPaymentModeID:"' + jQuery("#spnOldPaymentModeID").text() + '" ,oldPaymentMode:"' + jQuery("#spnOldPaymentMode").text() + '" ,oldBankName:"' + jQuery("#spnOldBankName").text() + '",oldRefNo:"' + jQuery("#spnOldRefNo").text() + '",LedgerTransactionNo:"' + jQuery("#spnLedgerTransactionNo").text() + '",LedgerNoDr:"' + jQuery("#spnLedgerNoDr").text() + '",Amount:"' + jQuery("#spnAmount").text() + '" }',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d == "1") {
                        jQuery("#spnErrorMsg").text('Record Saved Successfully');
                        jQuery('#txtReceiptNo').val('');
                        }
                        else {
                        jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            
                    }
                    clearAll();
                    },
                error: function (xhr, status) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');

                    jQuery('#btnSave').attr('disabled', false).val("Save");

                }
            });
        }

        function clearAll() {
            jQuery("#spnReceiptNo,#spnOldPaymentModeID,#spnOldBankName,#spnOldRefNo,#spnReceiptID,#spnOldPaymentMode,#spnLedgerTransactionNo,#spnLedgerNoDr,#spnAmount").text('');
            jQuery('#btnSave').attr('disabled', false).val("Save");
            jQuery("#tr_Mode").hide();
            jQuery('#PaymentOutput').html('');
            jQuery('#ddlBankName').prop("selectedIndex", 0);
            jQuery('#txtRefNo').val('');
            jQuery('#PaymentOutput,.paymentDetail,.paymentModeDetail').hide();
        }
        
    </script>
</asp:Content>

