
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" 
MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" 
CodeFile="~/Design/Recovery/PaymentConfirmation.aspx.cs" Inherits="Design_Recovery_PaymentConfirmation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager> 
   
    <script type="text/javascript">

     $(document).ready(function () {
        getPanelGroup();   
        getPanel($.trim($("#ddlPanelGroup").val()));   
        $('#txtFromDate').change(function () {
            ChkDate();
        });
        $('#txtToDate').change(function () {
            ChkDate();
        });                  
                        
        $("#btnSave").bind("click", function () {
            $("#spnErrorMsg").text('');
            $('#btnSave').attr('disabled', 'disabled');
            if ($("#btnSave").val() == "Save") {                 
                SavePaymentDetail();
            }
        });       
            
    });
       
  
    
      function ChkDate() {
        $.ajax({
            url: "../common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",DateTo:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value  + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $("#spnErrorMsg").text('To date can not be less than from date!');
                    $('#btnReport').attr('disabled', 'disabled');
                }
                else {
                     $("#spnErrorMsg").text('');
                    $('#btnReport').removeAttr('disabled');
                }
            }
        });

    }
        
        $(function () {           
        $("#btnsearch").bind("click", function () {
                $("#spnErrorMsg").text('');
                getRecoveryBill();
            });
        });

    

        $(document).ready(function(){
            $(".getpanel").change(function(){
                getPanel($.trim($("#ddlPanelGroup").val()));
            });
        });

    function getRecoveryBill()
        {
         $('#div_RecoveryBillSearch,#div_RecoveryBillDetail,#div_RecoveryBillDeatilHeader').hide();
            var chkDisp = "";
           if ($('#chkDisDate').is(":checked"))
           chkDisp = "1";
            else 
           chkDisp = "0";
            $.ajax({                                                                         
                url: "Services/Payment_Confirmation.asmx/SearchPaymentProcessRecoveryBill",
                data: '{InvoiceNo:"' + $.trim($("#txtInvoiceNo").val()) + '",IPNo:"' + $.trim($("#txtIPNo").val()) + '",PanelGroup:"' + $.trim($("#ddlPanelGroup").val()) + '",PanelID:"' + $.trim($("#ddlPanel").val()) + '",DispatchDate:"' + $.trim($("#txtDispatchDate").val()) + '",DocketNo:"' + $.trim($("#txtDocketNo").val()) + '",FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '",chkDisp:"' + chkDisp + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                RecoveryBillDetail = $.parseJSON(result.d);
                    if (RecoveryBillDetail != "0") {
                        var RecoveryBillOutPut = $('#tb_RecoveryBillSearch').parseTemplate(RecoveryBillDetail);
                        $('#div_RecoveryBillSearch').html(RecoveryBillOutPut);
                        $('#div_RecoveryBillSearch').show();
                    }
                    else {
                        $("#spnErrorMsg").text('Record Not Exist');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
     
     
     
    function getPanelGroup() {
        $("#ddlPanelGroup option").remove();
        $.ajax({
            url: "../common/CommonService.asmx/getPanelGroup",
            data: '{ }',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                PanelGroupData = $.parseJSON(result.d);
                if (PanelGroupData.length == 0) {
                    $("#ddlPanelGroup").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < PanelGroupData.length; i++) {
                        $("#ddlPanelGroup").append($("<option></option>").val(PanelGroupData[i].PanelGroup).html(PanelGroupData[i].PanelGroup));
                    }
                }
            },
            error: function (xhr, status) {
                $("#ddlPanelGroup").attr("disabled", false);
            }
        });
    }
    
    function getPanel(PnlGroup) {
        $("#ddlPanel option").remove();
        $.ajax({
            url: "../common/CommonService.asmx/getPanel",
            data: '{PanelGroup:"' + PnlGroup + '"}',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                PanelData = $.parseJSON(result.d);
                if (PanelData.length == 0) {
                    $("#ddlPanel").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < PanelData.length; i++) {
                        $("#ddlPanel").append($("<option></option>").val(PanelData[i].PanelID).html(PanelData[i].Company_Name));
                    }                        
                }
            },
            error: function (xhr, status) {
                $("#ddlPanel").attr("disabled", false);
            }
        });
    }
        
     function ShowPopUp(rowID) {
                $("#spnErrorMsg").text('');  $("#SpnConfirmErrorMsg").text('');
                document.getElementById('ctl00_ContentPlaceHolder1_txtRcvDate').value="";   
                document.getElementById('ctl00_ContentPlaceHolder1_txtChequeDate').value="";   
                $('#btnSave').removeAttr('disabled');       
                $('#txtRemark').val(''); 
                $('#txtChqAmt').val(''); 
                $('#lblTPAInvNo').text($(rowID).closest('tr').find('#tdTPAInvNo').text());
                $('#lblIPNo').text($(rowID).closest('tr').find('#tdIPNo').text());
                $('#lblTPAInvDate').text($(rowID).closest('tr').find('#tdTPAInvoiceDate').text());               
                $('#lblBillNo').text($(rowID).closest('tr').find('#tdBillNo').text());
                $('#lblBillAmt').text($(rowID).closest('tr').find('#tdBillAmt').text());
                $('#lblPName').text($(rowID).closest('tr').find('#tdPName').text());
                $('#lblPanel').text($(rowID).closest('tr').find('#tdPanel').text());  
                $('#lblUserRemark').text($(rowID).closest('tr').find('#tdUserRemark').text());                                                    
                $find('mpChange').show();            
        }
        
        function ClosePopUp() {
            $find('mpChange').hide();
        }           
        
        function SavePaymentDetail() {         
            if (validateItem() == true) {
                var resultItem = Item();
                    $.ajax({
                        url: "Services/Payment_Confirmation.asmx/SavePaymentDetail",
                          data: JSON.stringify({ Data: resultItem }),
                            type: "Post",
                            contentType: "application/json; charset=utf-8",
                            timeout: "120000",
                            dataType: "json",
                            success: function (result) {
                            var data = $.parseJSON(result.d);
                            if (data == "1") {
                                ClosePopUp();
                                getRecoveryBill();
                                $("#spnErrorMsg").text('Record Saved Successfully');   
                                $("#btnUpdateQuery").removeAttr('disabled');
                                $("#SpnConfirmErrorMsg").text('');
                                document.getElementById('ctl00_ContentPlaceHolder1_txtQExpDate').value="";
                            }
                            else {
                                   $("#SpnConfirmErrorMsg").text('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                                   $("#SpnConfirmErrorMsg").text('Error occurred, Please contact administrator');
                        }
                    });     
              }
              else {
                $('#btnSave').removeAttr('disabled');
            }               
        }
        
            function Item() {
                var Type=""
                if ($("#chkDeduction").is(':checked')) { 
                    Type="Deduction"; }  
                else if (!$("#chkDeduction").is(':checked')) { 
                    Type="Close"; }                  
                var data = new Array();
                var objItem = new Object();
                objItem.TPAInvNo= $('#lblTPAInvNo').text();
                objItem.IPNo= $('#lblIPNo').text();
                objItem.ChequeReceiveDate =$.trim(document.getElementById('ctl00_ContentPlaceHolder1_txtRcvDate').value);    
                objItem.ChequeDate =$.trim(document.getElementById('ctl00_ContentPlaceHolder1_txtChequeDate').value);            
                objItem.ChequeAmount =$.trim($("#txtChqAmt").val());    
                objItem.PaymentRemark =$.trim($("#txtRemark").val());  
                objItem.Type = Type;                                                                                  
                data.push(objItem);
                return data;
            }        
        
         function validateItem() {                    
                 if (document.getElementById('ctl00_ContentPlaceHolder1_txtRcvDate').value  == "") {
                    $("#SpnConfirmErrorMsg").text('Select Cheque Receive Date');
                    $('#txtRcvDate').focus();
                    return false;
                 }      
                
                 if (document.getElementById('ctl00_ContentPlaceHolder1_txtChequeDate').value  == "") {
                    $("#SpnConfirmErrorMsg").text('Select Cheque Date');
                    $('#txtChequeDate').focus();
                    return false;
                 }     
                
                 if ($.trim( $('#txtChqAmt').val()) == "") {
                    $("#SpnConfirmErrorMsg").text('Enter Cheque Amount');
                    $('#txtChqAmt').focus();
                    return false;
                 }
                
                 if ($.trim( $('#txtRemark').val()) == "") {
                    $("#SpnConfirmErrorMsg").text('Enter Remark');
                    $('#txtRemark').focus();
                    return false;
                 }                      
                
          return true;
        }
          
        </script>
    
        
       <script id="tb_RecoveryBillSearch" type="text/html">
        <table  id="tableRecoveryBill" border="1" style="width:970px;border-collapse:collapse;">       
		        <tr>
			        <th class="GridViewHeaderStyle" scope="col" style="width:60px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">UHID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">IP No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Patient Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel</th>            
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Bill No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Bill Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px">Invoice No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">Invoice Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;display:none;">Remark</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Select</th>            
		        </tr>
                   
            <#
             var dataLength=RecoveryBillDetail.length;        
             var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = RecoveryBillDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewLabItemStyle"  style="width:60px;" id="tdSNo"><#=(j+1)#></td>
                   <td class="GridViewLabItemStyle"  style="width:50px;display:none;" id="tdMRNo"><#=objRow.MRNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:50px;" id="tdIPNo"><#=objRow.IPNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle"  style="width:200px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>   
                    <td class="GridViewLabItemStyle"  style="width:150px;" id="tdBillNo"><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:50px;" id="tdBillAmt"><#=objRow.BillAmt#></td>       
                     <td class="GridViewLabItemStyle"  style="width:150px;" id="tdTPAInvNo"><#=objRow.TPAInvNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:80px;display:none;" id="tdTPAInvoiceDate"><#=objRow.TPAInvoiceDate#></td>  
                    <td class="GridViewLabItemStyle"  style="width:150px;display:none;" id="tdUserRemark"><#=objRow.UserRemark#></td>              
                    <td class="GridViewLabItemStyle"  style="width:70px;"> 
                        <img src="../../Images/edit.png" style="cursor:pointer" onclick="ShowPopUp(this)"  />                  
                    </td>   
		        </tr>
            <#}#>            
         </table>                            
          
    </script>
        
   
    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
               <b>Payment Confirmation</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <table cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                  
                        <td align="left" style="width: 20%">
                            &nbsp;Invoice No</td>
                        <td align="left" style="width: 30%">
                                <input type="text" id="txtInvoiceNo" tabindex="3"  title="Enter Invoice No" class="ItDoseTextinputText"   />
                            </td>
                        <td align="left" style="width: 20%">
                            IPD No.</td>
                        <td align="left" style="width: 30%">
                               <input type="text" id="txtIPNo" tabindex="3"  title="Enter IP No" class="ItDoseTextinputText"   />
                            </td>
                    </tr>
                    
                     <tr>
               
                        <td align="left" style="width: 20%; height: 22px;">
                            &nbsp;Panel Group</td>
                        <td align="left" style="width: 30%; height: 22px;">
                              <select id="ddlPanelGroup" tabindex="1" style="width: 100px" title="Select Panel"  class="getpanel"></select>
                             
                           </td>
                        <td align="left" style="width: 20%; height: 22px;">
                            Panel</td>
                        <td align="left" style="width: 30%; height: 22px;">
                             <select id="ddlPanel" tabindex="2" style="width: 250px" title="Select Panel"></select>
                             
                            </td>
                    </tr>
                    
                                       
                       <tr>
               
                        <td align="left" style="width: 20%; height: 24px;">
                            <input id="chkDisDate" type="checkbox"/>Dispatch Date
                            </td>
                        <td align="left" style="width: 30%; height: 24px;">                
              
                            <asp:TextBox ID="txtDispatchDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                         </td>
             
                        <td align="left" style="width: 20%; height: 24px;">
                           Docket No</td>
                        <td align="left" style="width: 30%; height: 24px;">               
                             <input type="text" id="txtDocketNo" tabindex="3"  title="Enter Docket No" class="ItDoseTextinputText" />                             
                            </td>
                    </tr>
                                                          
                    <tr>                  
                        <td align="left" style="width: 20%">
                              &nbsp;From Date
                              </td>
                        <td align="left" style="width: 30%">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </td>
                        <td align="left" style="width: 20%">
                            To Date</td>
                        <td align="left" style="width: 30%">
                           <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </td>
                    </tr>
                    
                </table>
            </div>
        </div>
        
        
     
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnsearch" value="Search" class="ItDoseButton" />
            &nbsp;
             <input type="button" id="btnreport" value="Report" class="ItDoseButton" />
        </div> 
        
         <div class="POuter_Box_Inventory" style="text-align: center;display:none;" id="div_RecoveryBillSearch">            
        </div>       
       
       
        
   </div>      
        
    <%--   Action Plan Start--%>
          <asp:Button ID="btnhide" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChange" BehaviorID="mpChange" runat="server" DropShadow="true" TargetControlID="btnhide" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlComment" X="40" Y="40">
     </cc1:ModalPopupExtender>     



        <asp:Panel ID="pnlComment" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:900px;">
            <div class="Purchaseheader">
                <table width="890">
                    <tr>
                        <td style="text-align:left;">
                            <b>Close Recovery Bill</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" onclick="ClosePopUp()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:897px;text-align:center;">
                <b><span id="SpnConfirmErrorMsg" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;">                                           
                    
                    <tr>
                        <td style="text-align:right;width:150px;">IP No :&nbsp;</td>
                        <td style="text-align:left;width:150px;"><span id="lblIPNo"></span>
                        <span id="lblTPAInvDate" style="display:none;"></span></td>
                        <td style="text-align:right;width:150px;">Patient Name :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblPName"></span></td>   
                        <td style="text-align:right;width:100px;">Invoice No :&nbsp;</td>
                        <td style="text-align:left;width:250px;"><span id="lblTPAInvNo"></span></td>                                                                                                                       
                    </tr>  
                                      
                    <tr>                   
                        <td style="text-align:right;width:150px;">Bill No :&nbsp;</td>
                        <td style="text-align:left;width:150px;"><span id="lblBillNo"></span></td>
                        <td style="text-align:right;width:150px;">Bill Amount :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblBillAmt"></span></td>
                        <td style="text-align:right;width:100px;">Panel :&nbsp;</td>
                        <td style="text-align:left;width:250px;"><span id="lblPanel"></span></td>
                    </tr>                           
                    
                     <tr>
                        <td style="text-align:right;width:150px;">User Remark :&nbsp;</td>
                        <td style="text-align:left;width:900px;" colspan="5"><span id="lblUserRemark"></span></td>                      
                    </tr>              
                </table>   
            </div>                          
           
           
            <div class="POuter_Box_Inventory" style="text-align: center;width:897px;" id="div1">       
        </div>             
            <div class="POuter_Box_Inventory" style="width:897px;text-align:center;">
                <b><span id="Span1" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;">                                           
                    <tr>
                      
                         <td style="text-align:right;width:200px;">Receive Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                             <asp:TextBox ID="txtRcvDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="CalRcvDate" runat="server" TargetControlID="txtRcvDate" Format="dd-MMM-yyyy"  />
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                        
                        </td>
                        
                        <td style="text-align:right;width:200px;">
                        Cheque Date :&nbsp;
                        </td>
                        <td style="text-align:left;width:200px;">
                            <asp:TextBox ID="txtChequeDate" runat="server" ToolTip="Click To Select Cheque Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="CalChkDate" runat="server" TargetControlID="txtChequeDate" Format="dd-MMM-yyyy"  />
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>
                        
                        <td style="text-align:right;width:200px;">Cheque Amount :&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                         <input type="text" id="txtChqAmt" tabindex="3" maxlength="7" title="Enter Cheque Amount" style="width:80px;" />
                         <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>
                    </tr>     
                    <tr>
                        <td style="text-align:right;width:200px;vertical-align:top;">Remark :&nbsp;</td>
                        <td style="text-align:left;width:800px;vertical-align:top;" colspan="5">
                           <input type="text" id="txtRemark" tabindex="3" maxlength="250" title="Enter Close Remark" style="width:650px;height:50px;" />
                         <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>                  

                    </tr> 
                    
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:600px;" colspan="5">
                         <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />&nbsp;&nbsp;
                         <span id="Spndeduction" style="color:Red; font-weight:bold;">In Case of Deduction</span>
                          <input id="chkDeduction" type="checkbox" />
                        </td>                                                
                    </tr> 
                    
                    
                                        
                             
                </table>   
            </div>                          
           
           
           
   
 
           
          </div>  
          
          
          
     
              
         
               
         
    </asp:Panel> 
        
    <%--   Action Plan END--%>
        
    
    
    
       
            
</asp:Content>
