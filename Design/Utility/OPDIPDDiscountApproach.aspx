<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDIPDDiscountApproach.aspx.cs" Inherits="Design_Utility_OPDIPDDiscountApproach" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>  
     <script type="text/javascript">
         $(document).ready(function () {
             LastUpdatedData();
             BindUtilityData();
             $('#ucFromDate').change(function () {
                 ChkDate();
             });
             $('#ucToDate').change(function () {
                 ChkDate();
             });
             $("input[id*=rbtFlat]").click(function () {
                 var value = $("[id*=rbtFlat] input:checked").val();
                 if (value == "Amt")
                     $("span[id*='spnFlat']").text('Enter Reduce Rate in (Amt) :');
                 else
                     $("span[id*='spnFlat']").text('Enter Reduce Rate in (%) :');
             });
             //$("input[id*=rbtOpdCriteria]").click(function () {
             //    BindOPDData();
             //    LastUpdatedData();
             //});
             $('#btnSearch').on("click", function (e) {
                 BindOPDData();
             });
             $('#btnCalculatedata').on("click", function (e) {
                 CalculateOPDData();
             });
             $('#btnSave').on("click", function (e) {
                 var x = confirm("Are you sure you want to Reduce Rate?");
                 if (x) {
                     SaveData();
                 }
                 else
                     return false;
                
             });
             $('#btnShowDetail').on("click", function (e) {
                 $("#divDetail").show();
             });
             $('#btnRevert').on("click", function (e) {
                 var x = confirm("Are you sure you want to Revert Rate?");
                 if (x) {
                     RevertData();
                 }
                 else
                     return false;
             });

             jQuery('#PatientDetailPopUp').animate({ top: -500 }, 500);
             jQuery('#OldPatient').click(function (e) {
                 jQuery('#PatientDetailPopUp').css('left', e.pageX - 830);
                 jQuery('#PatientDetailPopUp').css('left', e.pageY - 30);
                 jQuery('#PatientDetailPopUp').animate({ top: 70 }, 1000);
             });

             jQuery('#UtilityDetailPopUp').animate({ top: -500 }, 500);
             jQuery('#btnUtilityLog').click(function (e) {
                 jQuery('#UtilityDetailPopUp').css('left', e.pageX - 830);
                 jQuery('#UtilityDetailPopUp').css('left', e.pageY - 30);
                 jQuery('#UtilityDetailPopUp').animate({ top: 70 }, 1000);
             });
         });
         function closePatientDetail() {
             jQuery('#PatientDetailPopUp').animate({ top: -500 }, 500);
         }
         function closeUtilityDetail() {
             jQuery('#UtilityDetailPopUp').animate({ top: -500 }, 500);
         }
         
         function ChkDate() {
             $.ajax({
                 url: "../common/CommonService.asmx/CompareDate",
                 data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                 type: "POST",
                 async: true,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (mydata) {
                     var data = mydata.d;
                     if (data == false) {
                         $('#lblMsg').text('To date can not be less than from date!');
                         $('#btnSearch').attr('disabled', 'disabled');
                     }
                     else {
                         $('#lblMsg').text('');
                         $('#btnSearch').removeAttr('disabled');
                     }
                 }
             });
         }
         function SaveData() {
             var selectedItems = []; var selectedValues = [];
             $("#<%= chkCategory.ClientID %> input:checkbox:checked").each(function () {

                  selectedItems.push($(this).next().html());
                  selectedValues.push($(this).val());

             });

             $('#btnSave').attr('disabled', true).val("Submitting...");
             $.ajax({
                 url: "OPDIPDDiscountApproach.aspx/SaveData",
                 data: '{FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",Remarks:"' + $("#lblNetAmount").text() + '",OpdCriteria:"' + selectedValues + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     OPDData = $.parseJSON(result.d);
                     if (OPDData != null && result.d != "0") {
                         $("#divDetail").hide();
                         $("#lblNetAmount").text('');
                         $("#lblMsg").text('Rate Updated Suceesfully..');
                         alert('Rate Updated Suceesfully..');
                         BindUtilityData();
                         LastUpdatedData();
                         $('#btnSave').attr('disabled', false).val("Save");
                     }
                     else {
                         $("#divDetail").hide();
                         $("#lblNetAmount").text('');
                         $("#lblMsg").text('Error Occur. Please Contact to Administrator..');
                         $('#btnSave').attr('disabled', false).val("Save");
                     }
                 },
                 error: function (xhr, status) {
                     $("#divDetail").hide();
                     $("#lblNetAmount").text('');
                     $("#lblMsg").text('');
                     $('#btnSave').attr('disabled', false).val("Save");
                 }
             });
         }

         function RevertData() {
             var selectedItems = []; var selectedValues = [];
             $("#<%= chkCategory.ClientID %> input:checkbox:checked").each(function () {

                 selectedItems.push($(this).next().html());
                 selectedValues.push($(this).val());

             });

             $('#btnRevert').attr('disabled', true).val("Reverting...");
             $.ajax({
                 url: "OPDIPDDiscountApproach.aspx/RevertData",
                 data: '{FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",OpdCriteriaText:"' + selectedItems + '",OpdCriteria:"' + selectedValues + '",ReceiptNo:"' + $("#txtReceiptNo").val() + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     RevertData = $.parseJSON(result.d);
                     if (RevertData != null && result.d != "0") {
                         $("#lblMsg").text('Rate Updated Suceesfully..');
                         alert('Rate Reverted Suceesfully..');
                         LastUpdatedData();
                         BindUtilityData();
                         $('#btnRevert').attr('disabled', false).val("Rate Revert");
                     }
                     else {
                         $("#lblMsg").text('No Record for Revert..');
                         $('#btnRevert').attr('disabled', false).val("Rate Revert");
                     }
                 },
                 error: function (xhr, status) {
                     $("#lblMsg").text('Error Occur. Please Contact to Administrator..');
                     $('#btnRevert').attr('disabled', false).val("Rate Revert");
                 }
             });
         }
         function BindOPDData() {

             var selectedItems = []; var selectedValues = [];
             $("#<%= chkCategory.ClientID %> input:checkbox:checked").each(function () {

                 selectedItems.push($(this).next().html());
                 selectedValues.push($(this).val());

             });
           
             if (selectedValues != "") {
                 $('#btnSearch').attr('disabled', true).val("Searching...");

                 $.ajax({
                     url: "OPDIPDDiscountApproach.aspx/BindOPDData",
                     data: '{FromDate:"' + $("#ucFromDate").val() + '",ToDate:"' + $("#ucToDate").val() + '",OpdCriteria:"' + selectedValues + '",ReceiptNo:"' + $("#txtReceiptNo").val() + '",BillNo:"' + $("#txtBillNo").val() + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         OPDData = $.parseJSON(result.d);
                         if (OPDData != null && result.d != "0") {
                             $("#divDetail").show();
                             var htmlOutput = $("#scrptOPDData").parseTemplate(OPDData);
                             $("#divOPDDataShow").html(htmlOutput).show();
                             var TotalAmt = 0, Count = 0;
                             jQuery("#tb_opdItems tr").each(function () {
                                 var id = jQuery(this).closest("tr").attr("id");
                                 if (id != "opdItemHeader") {
                                     TotalAmt = parseFloat(TotalAmt) + parseFloat(jQuery(this).closest("tr").find("#tdNetAmount").html());
                                     Count = Count + 1;
                                 }
                             });
                             $("#lblNetAmount").text('Current Net Amount :Rs.' + parseFloat(TotalAmt).toFixed(2) + ' , New Net Amount :Rs.' + parseFloat(TotalAmt).toFixed(2) + ' and Difference :Rs.0');
                             $("#lblMsg").text('Total ' + Count + ' Receords Found..');
                             $('#btnSearch').attr('disabled', false).val("Search");
                         }
                         else {
                             $("#divDetail").hide();
                             $("#divOPDDataShow").html("").show();
                             $("#lblNetAmount").text('');
                             $("#lblMsg").text('No Record Found...');
                             $('#btnSearch').attr('disabled', false).val("Search");
                         }
                     },
                     error: function (xhr, status) {
                         $("#divDetail").hide();
                         $("#divOPDDataShow").html("").show();
                         $("#lblNetAmount").text('');
                         $("#lblMsg").text('Error..');
                         $('#btnSearch').attr('disabled', false).val("Search");
                     }
                 });
             }
             else {
                 $('#lblMsg').text('Please Select Atleast Category');
                 $("#lblNetAmount").text('');
                 $("#divDetail").hide();
                 $("#divOPDDataShow").html("").show();
             }
         }
         function BindUtilityData() {
                $.ajax({
                    url: "OPDIPDDiscountApproach.aspx/BindUtilityData",
                     data: '{}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         UtilityData = $.parseJSON(result.d);
                         if (UtilityData != null && result.d != "0") {
                             var htmlOutput = $("#scrptUtilityData").parseTemplate(UtilityData);
                             $("#divUtilityDataShow").html(htmlOutput).show();
                             }
                         else {
                             $("#divUtilityDataShow").html("").show();
                         }
                     },
                     error: function (xhr, status) {
                         $("#divUtilityDataShow").html("").show();
                     }
                 });
         }

         function LastUpdatedData() {
             $.ajax({
                 url: "OPDIPDDiscountApproach.aspx/LastUpdatedData",
                 data: '{}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     LastUpdated = $.parseJSON(result.d);
                     if (LastUpdated != null && result.d != "0") {
                         $("#lblMsg").text(LastUpdated);
                     }
                     else {
                         $("#lblMsg").text('');
                     }
                 },
                 error: function (xhr, status) {
                     $("#lblMsg").text('');
                 }
             });
         }
         function CalculateOPDData() {
             var selectedItems = []; var selectedValues = [];
             $("#<%= chkCategory.ClientID %> input:checkbox:checked").each(function () {

                 selectedItems.push($(this).next().html());
                 selectedValues.push($(this).val());

             });
           
             if (selectedValues != "") {
                 $('#btnCalculatedata').attr('disabled', true).val("Calculating...");
                 $.ajax({
                     url: "OPDIPDDiscountApproach.aspx/CalculateOPDData",
                     data: '{FromDate:"' + $("#ucFromDate").val() + '",ToDate:"' + $("#ucToDate").val() + '",OpdCriteria:"' + selectedValues + '",ReduceType:"' + $("[id*=rbtFlat] input:checked").val() + '",RateReduce:"' + $("#txtFlatDisc").val() + '",MinimumRate:"' + $("#txtMinimumRate").val() + '",ReceiptNo:"' + $("#txtReceiptNo").val() + '",BillNo:"' + $("#txtBillNo").val() + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         CalculatedData = $.parseJSON(result.d);
                         if (CalculatedData != null && result.d != "0") {
                             $("#lblNetAmount").text(CalculatedData);
                             $("#btnSave").show();
                             $('#btnCalculatedata').attr('disabled', false).val("Calculate Data");
                             $('#lblMsg').text('');
                         }
                         else {
                             $("#lblNetAmount").text('');
                             $("#btnSave").hide();
                             $('#btnCalculatedata').attr('disabled', false).val("Calculate Data");
                             $('#lblMsg').text('No Record Found..');
                         }
                     },
                     error: function (xhr, status) {
                         $("#lblNetAmount").text('');
                         $("#btnSave").hide();
                         $('#btnCalculatedata').attr('disabled', false).val("Calculate Data");
                         $('#lblMsg').text('Error..');
                     }
                 });
             }
             else {
                 $('#lblMsg').text('Please Select Atleast Category');
                 $("#lblNetAmount").text('');
                 $("#btnSave").hide();
             }
         }
      </script>
   
    <script type="text/javascript">

        function SelectAll() {
            if ($('#chkSelectAll').is(":checked")) {
                $("#<%= chkCategory.ClientID%> input[type=checkbox]").attr("checked", "checked");
            }
            else {
                $("#<%= chkCategory.ClientID%> input[type=checkbox]").removeAttr("checked");
            }
        }
    </script>
      <script type="text/html" id="scrptOPDData">
        <table class="FixedTables" cellspacing="0" rules="all" id="tb_opdItems" border="1" style="border-collapse:collapse; width:100%;">
            <tr id="opdItemHeader">  
                   
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S/No.</th>      
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Receipt No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">PatientName</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Bill Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Net Amt.</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Paid Amt.</th>
                                           
             </tr>
            <#       
		    var dataLength=OPDData.length;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = OPDData[j];               
		    #>
            <tr>                               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                        
                <td class="GridViewLabItemStyle" id="tdReceiptNo" style="width:150px;text-align:left; "><#=objRow.ReceiptNo#></td>    
				<td class="GridViewLabItemStyle" id="tdPatientID" style="width:100px;text-align:right; "><#=objRow.PatientID#></td>
                <td class="GridViewLabItemStyle" id="tdPName" style="width:200px;text-align:left; "><#=objRow.PName#></td>	
                <td class="GridViewLabItemStyle" id="tdDate" style="width:100px;text-align:center; "><#=objRow.DATE#></td>    
				<td class="GridViewLabItemStyle" id="tdNetAmount" style="width:70px;text-align:right; "><#=objRow.NetAmount#></td>
                <td class="GridViewLabItemStyle" id="tdPaidAmount" style="width:70px;text-align:right; "><#=objRow.PaidAmount#></td>		                    
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>
     <script type="text/html" id="scrptUtilityData">
        <table class="FixedTables" cellspacing="0" rules="all" id="tb_UtilityLog" border="1" style="border-collapse:collapse; width:100%;">
            <tr id="Tr1">  
                   
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;text-align:center;">Revert</th>      
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;text-align:center;">Utility Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;text-align:center;">From Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;text-align:center;">To Date</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:450px;">Modified Summary Data</th>
                                           
             </tr>
            <#       
		    var dataLength=UtilityData.length;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = UtilityData[j];               
		    #>
            <tr>                               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>   
                <td class="GridViewLabItemStyle" id="tdIsRevert" style="width:50px;text-align:center; "><#=objRow.IsRevert#></td>
                <td class="GridViewLabItemStyle" id="tdCreatedDate" style="width:70px;text-align:center; "><#=objRow.CreatedDate#></td>    
				<td class="GridViewLabItemStyle" id="tdUtilityFromDate" style="width:70px;text-align:center; "><#=objRow.FromDate#></td>
                <td class="GridViewLabItemStyle" id="tdUtilityToDate" style="width:70px;text-align:center; "><#=objRow.ToDate#></td>	
                <td class="GridViewLabItemStyle" id="tdRemarks" style="width:450px;text-align:left; "><#=objRow.Remarks#></td>	                    
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory">
            <div class="content">
                &nbsp;<div style="text-align: center;">
                    <b>OPD Discount Approach</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="div4" runat="server" style="text-align: center; display:none;">
            <div class="Purchaseheader">
                Searching Criteria
            </div>
            <asp:RadioButtonList ID="rbtOpdCriteria" runat="server" CssClass="radioBtnClass" RepeatDirection="Horizontal" ClientIDMode="Static">
                <asp:ListItem Value="Consultation" Selected="True">OPD Consultation</asp:ListItem>
                 <asp:ListItem Value="Lab">OPD Diagnosis(Lab,Radio,Others)</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div class="POuter_Box_Inventory" id="divOPDSearch" runat="server">
            <div class="Purchaseheader">
                OPD Utility
            </div>
            <table style="width: 100%">
                <tr>
                    <td  style="text-align:left; height: 26px;">From Date :&nbsp;
                    </td>
                    <td style="height: 26px">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="129px" TabIndex="1" ClientIDMode="Static"></asp:TextBox><cc1:CalendarExtender ID="cdFrom" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                    </td>
                    <td style="text-align:right; height: 26px;">To Date :&nbsp;
                    </td>
                    <td style="height: 26px;">
                        <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select To Date" Width="129px" TabIndex="2" ClientIDMode="Static"></asp:TextBox> <cc1:CalendarExtender ID="cdTo" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender> 
                    </td>
                    <td style="text-align:right;"><input type="button" id="btnUtilityLog" class="ItDoseButton" value="View Utility Log" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                </tr>
                 <tr>
                    <td  style="text-align:left; height: 26px;">Receipt No. :&nbsp;
                    </td>
                    <td style="height: 26px"> <asp:TextBox ID="txtReceiptNo" runat="server" ToolTip="Enter Receipt No." Width="129px" TabIndex="3" ClientIDMode="Static" ></asp:TextBox>
                         </td>
                    <td style="text-align:right; height: 26px;">&nbsp;
                    </td>
                    <td style="height: 26px" colspan="2"> <asp:TextBox ID="txtBillNo" runat="server" ToolTip="Enter Bill No." Style=" display:none;" Width="129px" TabIndex="4" ClientIDMode="Static" ></asp:TextBox>
                       </td>
                </tr>
                 <tr >
                    <td style="text-align:left">
                    <input type="checkbox" id="chkSelectAll" onclick="SelectAll();" />Category :&nbsp;</td>
                    <td  colspan="4">
                      <select id="ddlCategory" style="width:240px;display:none"  ></select>
                        <asp:CheckBoxList ID="chkCategory" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal"  RepeatColumns="3"></asp:CheckBoxList>
                    </td>
                  
                </tr>
                <tr>
                    <td  style="text-align:center" colspan="5">
                        <input type="button" id="btnSearch" class="ItDoseButton" value="Search" tabindex="5" />
                         <input type="button" id="btnRevert" class="ItDoseButton" value="Rate Revert" />
                    </td>
                    
                </tr>
              </table>
        </div>
       
     <div class="POuter_Box_Inventory" style="text-align: center;display:none;" id="divDetail" >
        <table style="width:99%">
             <tr>
                    <td colspan="6" style="text-align:right">
                        <input type="button" id="OldPatient" class="ItDoseButton" value="View Data in Detail" />
                 </td>
              </tr>
            <tr>
                    <td  style="text-align:right; width:20%;">Min. Rate For Apply : &nbsp;</td>
                    <td style="text-align:left; width:10%;">
                       <asp:TextBox ID="txtMinimumRate" runat="server" ClientIDMode="Static" Width="100px" MaxLength="10" TabIndex="6" ></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FT1" runat="server" FilterType="Numbers" TargetControlID="txtMinimumRate" /> </td>
                <td style="width:12%; text-align:right;">Reduce Type :&nbsp;</td>
                    <td style="width:20%; text-align:left;">
                        <asp:RadioButtonList ID="rbtFlat" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" TabIndex="7" >
                                    <asp:ListItem Value="Amt" Selected="True">Amount</asp:ListItem>
                                    <asp:ListItem Value="Percent">Percent</asp:ListItem>
                        </asp:RadioButtonList></td>
                 <td style="width:25%; text-align:right;"><span id="spnFlat">Enter Reduce Rate in (Amt) :</span></td>
                
                    <td style="text-align:left; width:15%;" >&nbsp;
                        <asp:TextBox ID="txtFlatDisc" runat="server" ClientIDMode="Static" Width="100px"  MaxLength="10" TabIndex="8"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FT4" runat="server" FilterType="Numbers" TargetControlID="txtFlatDisc" />
                         </td>
                  </tr>
             <tr>
                    <td  colspan="6" style="text-align:left;;color:blue" >Notes : If Item Rate is less than 'Min. Rate For Apply' then Rate will not be reduced. </td>
                    
                  </tr>
                <tr>
                    <td colspan="6" style="text-align:center"> 
                        <input type="button" id="btnCalculatedata" class="ItDoseButton" value="Calculate Data" tabindex="9" />
                    </td>
                  </tr>
                <tr>
                    <td colspan="6" > 
                                </td>
                  </tr>
          </table>
         
            <div class="POuter_Box_Inventory" style="text-align: center; width:99.5%">
                <asp:Label ID="lblNetAmount" CssClass="ItDoseLblError" ClientIDMode="Static" Font-Size="Medium" runat="server" ></asp:Label>
                <br />
                  <input type="button" id="btnSave" class="ItDoseButton" value="Save" style="display:none" tabindex="10" />
                  </div>
        </div>
          <div id="PatientDetailPopUp" style=" position: absolute; top: -500px; border-collapse:collapse; overflow-x:hidden; overflow-y:hidden ">
               <div  style="width: 890px;">
               <div class="Purchaseheader" style="text-align:right">&nbsp;
                    <em ><span style="font-size: 7.5pt" class="shat"> 
                    Click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closePatientDetail()"/>                               
                                to close</span></em>
                     </div>
                   
                   <div class="POuter_Box_Inventory" style="width: 886px; ">
                <div class="Purchaseheader" style="text-align:center">
                    Data For Modification Rate
                </div>
                <div id="divOPDDataShow" style="max-height: 266px; overflow-x: auto; background-color: #eaf3fd;">
                        </div>
            </div>  
    </div> 
</div>
<div id="UtilityDetailPopUp" style=" position: absolute; top: -500px; border-collapse:collapse; overflow-x:hidden; overflow-y:hidden ">
               <div  style="width: 890px;">
               <div class="Purchaseheader" style="text-align:right">&nbsp;
                    <em ><span style="font-size: 7.5pt" class="shat"> 
                    Click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeUtilityDetail()"/>                               
                                to close</span></em>
                     </div>
                   
                   <div class="POuter_Box_Inventory" style="width: 886px; ">
                <div class="Purchaseheader" style="text-align:center">
                    All Utility Logs
                </div>
                <div id="divUtilityDataShow" style="max-height: 266px; overflow-x: auto; background-color: #eaf3fd;">
                        </div>
            </div>  
    </div> 
</div>
    </div>
</asp:Content>
