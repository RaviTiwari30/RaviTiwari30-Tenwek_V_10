
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" 
MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" 
CodeFile="~/Design/Recovery/RecoveryBillRegister.aspx.cs" Inherits="Design_Recovery_RecoveryBillRegister" %>

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
        
         $("#btnreport").bind("click", function () {
             window.open('data:application/vnd.ms-excel,' + encodeURIComponent( $('div[id$=div_RecoveryBillSearch]').html()));          
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
                getBill();
            });
        });

    

        $(document).ready(function(){
            $(".getpanel").change(function(){
                getPanel($.trim($("#ddlPanelGroup").val()));
            });
        });

    function getBill()
        {
         $('#div_RecoveryBillSearch,#div_RecoveryBillDetail,#div_RecoveryBillDeatilHeader').hide();
            var chkDisp = "";
              var IsTPAInvActive="0";
          if ($("#rdoYes").is(':checked'))   
               IsTPAInvActive="1";

           if ($('#chkDisDate').is(":checked"))
           chkDisp = "1";
            else 
           chkDisp = "0";
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/SearchBill",
                data: '{InvoiceNo:"' + $.trim($("#txtInvoiceNo").val()) + '",IPNo:"' + $.trim($("#txtIPNo").val()) + '",FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '",IsTPAInvActive:"' + IsTPAInvActive + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                RecoveryBillDetail = $.parseJSON(result.d);
                    if (RecoveryBillDetail != "0") {
                      $("#spnErrorMsg").text(RecoveryBillDetail.length + ' Record Found');
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
            url: "Services/Recovery_Action.asmx/getPanelGroup",
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
            url: "Services/Recovery_Action.asmx/getPanel",
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
        
        
     
        
          
        </script>
    
        
       <script id="tb_RecoveryBillSearch" type="text/html">
        <table  id="tableRecoveryBill" border="1" style="width:950px;border-collapse:collapse;">       
		        <tr>
			        <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">UHID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IP No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Patient Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:170px;">Panel</th>            
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Bill No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Bill Amt</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;display:none;">Invoice No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Admission Date</th>  
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Discharge Date</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Bill Date</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Dispatch Date</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Invoice Date</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Receiving Date</th>  
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Uploaded Date</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Invoice Closed Date</th>         
		        </tr>
                   
            <#
             var dataLength=RecoveryBillDetail.length;        
             var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = RecoveryBillDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewLabItemStyle"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                   <td class="GridViewLabItemStyle"  style="width:60px;" id="tdMRNo"><#=objRow.MRNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:60px;" id="tdIPNo"><#=objRow.IPNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle"  style="width:170px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>   
                    <td class="GridViewLabItemStyle"  style="width:130px;" id="tdBillNo"><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:70px;" id="tdBillAmt"><#=objRow.BillAmt#></td>       
                    <td class="GridViewLabItemStyle"  style="width:150px;display:none;" id="tdTPAInvNo"><#=objRow.TPAInvNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdDateofAdmit"><#=objRow.DateOfAdmit#></td>     
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdDateofDischarge"><#=objRow.DateOfDischarge#></td>    
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdBillDate"><#=objRow.BillDate#></td>    
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdDispatchDate"><#=objRow.DispatchDate#></td>
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdTPAInvoiceDate"><#=objRow.TPAInvoiceDate#></td>    
                    <td class="GridViewLabItemStyle"  style="width:100px;display:none;" id="tdReceivingDate"><#=objRow.ReceivingDate#></td>    
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdUploadedDate"><#=objRow.UploadedDate#></td>  
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdTPAInvClosedDate"><#=objRow.TPAInvClosedDate#></td>           
		        </tr>
            <#}#>            
         </table>                            
          
    </script>
        
   
    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
               <b>Credit Bill Register</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <table cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                  
                        <td align="left" style="width: 20%">
                            &nbsp;Invoice No :</td>
                        <td align="left" style="width: 30%">
                                <input type="text" id="txtInvoiceNo" tabindex="3"  title="Enter Invoice No" class="ItDoseTextinputText"   />
                            </td>
                        <td align="left" style="width: 20%">
                            IPD No :</td>
                        <td align="left" style="width: 30%">
                               <input type="text" id="txtIPNo" tabindex="3"  title="Enter IP No" class="ItDoseTextinputText"   />
                            </td>
                    </tr>
                    
                     <tr style="display:none;">
               
                        <td align="left" style="width: 20%; height: 22px;">
                            &nbsp;Panel Group :</td>
                        <td align="left" style="width: 30%; height: 22px;">
                              <select id="ddlPanelGroup" tabindex="1" style="width: 100px" title="Select Panel"  class="getpanel"></select>
                             
                           </td>
                        <td align="left" style="width: 20%; height: 22px;">
                            Panel :</td>
                        <td align="left" style="width: 30%; height: 22px;">
                             <select id="ddlPanel" tabindex="2" style="width: 250px" title="Select Panel"></select>
                             
                            </td>
                    </tr>
                    
                                       
                       <tr style="display:none;">
               
                        <td align="left" style="width: 20%; height: 24px;">
                            <input id="chkDisDate" type="checkbox"/>Dispatch Date :
                            </td>
                        <td align="left" style="width: 30%; height: 24px;">                
              
                            <asp:TextBox ID="txtDispatchDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                         </td>
             
                        <td align="left" style="width: 20%; height: 24px;">
                           Docket No :</td>
                        <td align="left" style="width: 30%; height: 24px;">               
                             <input type="text" id="txtDocketNo" tabindex="3"  title="Enter Docket No" class="ItDoseTextinputText" />                             
                            </td>
                    </tr>
                                                          
                    <tr>                  
                        <td align="left" style="width: 20%">
                              &nbsp;From Date :
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
                    
                    <tr>
                  
                        <td align="left" style="width: 20%" >
                            &nbsp;Invoice Generated :                               
                            </td>                      
                        <td align="left" style="width: 80%" colspan="3">                          
                            <input id="rdoYes" type="radio" name="rdochk" value="Yes" checked="checked" />Yes
                            <input id="rdoNo" type="radio" name="rdochk" value="No" />No  
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
        
         <div class="POuter_Box_Inventory" style="text-align: center;display:none; overflow:scroll; height:450px;" id="div_RecoveryBillSearch">            
        </div>       
       
       
        
   </div>      
        
   
            
</asp:Content>
