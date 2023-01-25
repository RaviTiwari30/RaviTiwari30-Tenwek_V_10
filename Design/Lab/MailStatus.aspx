<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MailStatus.aspx.cs" Inherits="Design_Lab_MailStatus" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript">
    
    $(document).ready(function () {
        $("#btnSearch").click(MailSearch);
        $("#btnSendMail").click(Sendmail);

    });

    var PatientData = "";
    var SearchType = "";
    

</script>
    <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
  <Services>
  <Ajax:ServiceReference Path="~/Lis.asmx" />
 
  </Services>
     </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Mail Status</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        
        <div class="POuter_Box_Inventory">                                            
                        <table style="width:100%;border-collapse:collapse">
                            <tr>
                                <td style="text-align:right;width:16%">
                                            
                            From Lab No. :&nbsp;</td>
                                <td style="text-align:left;width:30%">
                        <asp:TextBox ID="txtFromLabNo" runat="server"  Width="150px" />
                                </td>
                                <td style="text-align:right;width:20%">
                    
                            To Lab No :&nbsp;</td>
                                <td style="text-align:left;width:34%"><asp:TextBox ID="txtToLabNo" runat="server"  Width="150px" /></td>
                            </tr>
                            <tr>
                                <td style="text-align:right;width:16%">
                       
                            Lab No. :&nbsp;</td>
                                <td style="text-align:left;width:30%">
                        <asp:TextBox ID="txtLabNo" runat="server"  Width="150px" />
                                </td>
                                <td style="text-align:right;width:20%">
                       
                            UHID :&nbsp;</td>
                               <td style="text-align:left;width:34%">
                        <asp:TextBox ID="txtMRNo" runat="server"  Width="150px" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">
                       
                            Patient Name :&nbsp;</td>
                               <td style="text-align:left;width:16%">
                        <asp:TextBox ID="txtPName" runat="server"  Width="150px" />
                                </td>
                                <td style="text-align:right">
                        
                       
                            Center :&nbsp;</td>
                               <td style="text-align:left;width:20%">
                        <asp:DropDownList ID="ddlCentreAccess" Width="206px" runat="server">
                        </asp:DropDownList>
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="text-align:right;width:16%">
                       
                            Department :&nbsp;</td>
                                <td style="text-align:left;width:20%">
                        <asp:DropDownList ID="ddlDepartment" Width="206px" runat="server">
                            </asp:DropDownList>
                                </td>
                                <td style="text-align:right">
                       
                            Refer By :&nbsp;</td>
                                <td><asp:DropDownList ID="ddlReferDoctor" Width="206px" runat="server"></asp:DropDownList>
                        
                                </td>
                            </tr>
                            <tr>
                               <td style="text-align:right;width:16%">
                        
                            Contact No. :&nbsp;</td>
                                <td style="text-align:left;width:20%">
                                    <asp:TextBox ID="txtContactNo" runat="server" 
                                Width="150px" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbContactNo" runat="server" TargetControlID="txtContactNo"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                </td>
                                <td style="text-align:right">
                       
                            <%--Type :&nbsp;--%></td>
                                <td><asp:RadioButtonList ID="rblInputType" runat="server" RepeatDirection="Horizontal" style="display:none"
                            CssClass="ItDoseRadiobuttonlist" >
                            <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                        </asp:RadioButtonList>
                        
                                </td>
                            </tr>
                            <tr>
                               <td style="text-align:right;width:16%">
                            
                            Patient Type :&nbsp;</td>
                                <td>
                            <asp:DropDownList ID="ddlPatientType" runat="server" Width="206px">
    <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
    <asp:ListItem Value="1">Urgent</asp:ListItem>
</asp:DropDownList></td>
                                <td style="text-align:right">
                       
                            Panel :&nbsp;</td>
                                <td>
                            <asp:DropDownList ID="ddlPanel" runat="server" Width="206px"></asp:DropDownList>
                                </td>
                            </tr>
                           
                            <tr>
                                <td style="text-align:right">
                       
                            Status :&nbsp;</td>
                                <td style="text-align:left;width:20%">
                        <asp:DropDownList ID="ddlStatus" Width="206px" runat="server">
                        
                            <asp:ListItem Value="1">Approved</asp:ListItem>
                          
                            </asp:DropDownList></td>
                                <td style="text-align:right">
                            <asp:CheckBox ID="chkPrintHeader" Text="Print Header" runat="server"  />
                     
                                </td>
                                <td>
                        
                        <asp:RadioButtonList ID="rblsearchType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist">
                            <asp:ListItem Text="Panel" Value="1" ></asp:ListItem>
                               <asp:ListItem Text="Doctor" Value="3" ></asp:ListItem>
                            <asp:ListItem Text="Patient" Value="2" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">
                       
                            From Date :&nbsp;</td>
                                <td>
                              <asp:TextBox ID="txtFromDate" runat="server" ReadOnly="true" Width="100px" ClientIDMode="Static"></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="calFromDate"
    TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        
                                                              
                                </td>
                                <td style="text-align:right">                                                                    
                            To Date :&nbsp;</td>
                                <td>
                       <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true" Width="100px" ClientIDMode="Static"></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"/>
                                                                               
                                </td>
                            </tr>
                        </table>                                                                                           
            </div>                      
        <div class="POuter_Box_Inventory" style="text-align: center;">   
            <table style="text-align:center;width:100%;border-collapse:collapse" >
                        <tr  style="text-align:center">
                            <td colspan="10" style="text-align:center">

                                            
                     <input id="btnSearch" type="button" value="Search"  class="ItDoseButton"  />
                &nbsp; &nbsp;
                <input type="button" id="btnSendMail" class="ItDoseButton" value="Send Mail"  />              
                     </td>  
                            <tr>
                            <td>
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            </td>

                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align:left">&nbsp;Approved
                                </td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align:left">
                                &nbsp;Requested for Mail</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: White;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align:left">
                                &nbsp;Not Approved</td>
                                 
                               <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #3399FF;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align:left">
                               &nbsp;Mail Sent</td>

                               <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #E2680A;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                           <td style="text-align:left">
                              &nbsp;Sending Fail</td>
                                <td>
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            </td>
                        </tr>
                    </table>
                                                            
            </div>
       
        <div class="POuter_Box_Inventory" style="display:none" id="divResult">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div id="MailSearchOutput" style="max-height:350px; overflow-y:auto; overflow-x:hidden;">
            
                
            </div>
    </div>
    
    </div>
   
    <script id="tb_PatientLabSearch" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="width:955px;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">UHID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Lab No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:145px;">Panel Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:145px;">Patient Name</th>
			
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Age/Sex</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Investigation</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Email ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:5px;"><input type="checkbox" id="chkAll" onClick="checkAll()" /></th>
</tr>
       <#
       
              var dataLength=PatientData.length;
             
              var objRow;   
              var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
      status=objRow.rowColor.replace("#","");
         
            #>
                    <tr id="<#=objRow.LedgerTransactionNo#>|<#=objRow.Test_ID#>|0"  
                    style="background-color:<#=objRow.rowColor#>;">
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle"><#=objRow.PatientID#></td>
<td class="GridViewLabItemStyle" id="labno"><#=objRow.LedgerTransactionNo#></td>
<td class="GridViewLabItemStyle"><#=objRow.PanelName#></td>
<td class="GridViewLabItemStyle" id="pname"><#=objRow.pname#></td>
<td class="GridViewLabItemStyle"><#=objRow.age#></td>
<td class="GridViewLabItemStyle" id="testname"><#=objRow.ObservationName#></td>
<td class="GridViewLabItemStyle"><input type="textbox" id="txtEmailID" 
<# if( SearchType=="1") {#>value="<#=objRow.PanelMailID#>"<#}else if( SearchType=="3") {#>value="<#=objRow.DoctorEmailId#>"<#  }else{#>value="<#=objRow.PatientMailID#>"<#}#>></td>

<td class="GridViewLabItemStyle"  style="width:80px;"><#=objRow.InDate#></td>
<td class="GridViewLabItemStyle" style="text-align:center width:5px;"><input type="checkbox" id="chkMail" <# if(status!='90EE90'){  #> alt='false' style='' <# }else{ #> alt='true'<#}#> />
</td>


<td id="reporttype" style="display:none;"><#=objRow.ReportType#></td>
<td id="testid" style="display:none;"><#=objRow.Test_ID#></td>
                        
</tr>

            <#}#>

     </table>    
    </script>
    
    
      <script type="text/javascript" >
          function checkAll() {
              if ($('#chkAll').is(':checked')) {
                  $('#tb_grdLabSearch tr').each(function () {
                      $(this).find('#chkMail').attr("checked", true);
                  });
              }
              else {
                  $('#tb_grdLabSearch tr').each(function () {
                      $(this).find('#chkMail').attr("checked", false);
                  });
              }
          }
    </script>
    <script type="text/javascript">
        function MailSearch() {
            $("#btnSearch").attr('disabled', true).val("Searching...");
            $("#MailSearchOutput").empty();
           // $("#<%=lblMsg.ClientID %>").text('');
        $.ajax({
            url: "services/MapInvestigationObservation.asmx/SearchMail",
            data: '{ LabNo: "' + $("#<%=txtLabNo.ClientID %>").val() + '",MRNo:"' + $("#<%=txtMRNo.ClientID %>").val() + '",PName:"' + $("#<%=txtPName.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFromDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",Dept:"' + $("#<%=ddlDepartment.ClientID %>").val() + '",Status:"' + $("#<%=ddlStatus.ClientID %>").val() + '",ContactNo:"' + $("#<%=txtContactNo.ClientID %>").val() + '",ReferBy:"' + $("#<%=ddlReferDoctor.ClientID%>").val() + '",Ptype:"' + $("#<%=ddlPatientType.ClientID%>").val() + '",FromLabNo: "' + $("#<%=txtFromLabNo.ClientID %>").val() + '",ToLabNo: "' + $("#<%=txtToLabNo.ClientID %>").val() + '",PanelID: "' + $("#<%=ddlPanel.ClientID %>").val() + '",InputType:"' + $('#<%=rblInputType.ClientID%> input[type=radio]:checked').val() + '" }',
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                PatientData = jQuery.parseJSON(result.d);
                if ($('#<%=rblsearchType.ClientID%> input[type=radio]:checked').val() == "1")
                SearchType = "1";

            else if ($('#<%=rblsearchType.ClientID%> input[type=radio]:checked').val() == "3")
                SearchType = "3";
            else 
                SearchType = "2";
            var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
            $('#MailSearchOutput').html(output);
            $('#divResult').show();
            $("#btnSearch").attr('disabled', false).val("Search");
        },
            error: function (xhr, status) {
                $("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                $('#divResult').hide();
                $("#btnSearch").attr('disabled', false).val("Search");
        }
        });

    };
    function Sendmail() {
        $("#<%=lblMsg.ClientID %>").text('');
        var PHead = 0;
        var MailData = '';
        var Type = 1;
        var ischk = '<%= Session["LoginType"].ToString() %>';
        if (ischk == "RADIOLOGY")
            Type = 3;
        else
            Type = 1;
        $("#tb_grdLabSearch tr").find('#chkMail').filter(':checked').each(function () {
            MailData += $(this).closest("tr").attr("id") + '|' + $(this).closest("tr").find("#txtEmailID").val() + '|' + $(this).closest("tr").find("#pname").html() + '|' + $(this).closest("tr").find("#testname").html() + "#";
            if ($("#<%=chkPrintHeader.ClientID %>").attr("checked"))
                PHead = 1;
        });
        if (MailData == '') {
            $("#<%=lblMsg.ClientID %>").text('No Record Selected');
            return;
        }
        $.ajax({
            url: "services/MapInvestigationObservation.asmx/SendMail",
            data: '{PanelID: "' + $("#<%=ddlPanel.ClientID %>").val() + '",TestID:"' + MailData + '",PHead:"' + PHead + '",LoginType:"' + Type + '" }',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                if (result.d == '1')
                    $("#<%=lblMsg.ClientID %>").text('Record Saved Successfully');
                else
                    $("#<%=lblMsg.ClientID %>").text('Record Not Saved ');
                MailSearch();
            },
            error: function (xhr, status) {
                $("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');


            }
        });


        }
    </script>
    <script type="text/javascript" >
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#<%=lblMsg.ClientID %>").text('To date can not be less than from date!');
                        $('#btnSearch,#btnSendMail').attr('disabled', 'disabled');
                        $('#divResult').hide();

                    }
                    else {
                        $("#<%=lblMsg.ClientID %>").text('');
                        $('#btnSearch,#btnSendMail').removeAttr('disabled');
                        
                    }
                }
            });

        }
        </script>
</asp:Content>

