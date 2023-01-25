<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDOutStandingReport.aspx.cs" Inherits="Design_IPD_IPDOutStandingReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
     <script type="text/javascript" >
         $(function () {
             $('#ucFromDate').change(function () {
                 ChkDate();
             });
             $('#ucToDate').change(function () {
                 ChkDate();
             });
         });
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
                         $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                     }
                     else {
                         $('#<%=lblMsg.ClientID %>').text('');
                     }
                 }
             });
         }
         function checkAllCentre() {
             var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

                 if (status == true) {
                     $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
                 }
                 else {
                     $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
                 }
             }
             function chkCentreCon() {
                 if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
             }
         $(function () {
             $("[id*=chkPanel]").bind("click", function () {
                 if ($(this).is(":checked")) {
                     $("[id*=chlPanel] input").attr("checked", "checked");
                 } else {
                     $("[id*=chlPanel] input").removeAttr("checked");
                 }
             });
         });
 </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Patient OutStanding Report </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
             <div class="col-md-1"></div>
                <div class="col-md-24">
                     <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">
                             <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-21">
                         <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                    </div>
                    </div>
                    <div class="row">
                     <div class="col-md-3">
                        <label class="pull-left">
                           Type
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rdbreporttype" runat="server" RepeatDirection="Horizontal"> 
                            <asp:ListItem Value="O">OPD</asp:ListItem>
                            <asp:ListItem Value="I">IPD</asp:ListItem>
                            <asp:ListItem Value="A" Selected="True">All</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                 </div> 
                    <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                           Outstanding As On
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-13">
                         <asp:RadioButtonList ID="rdbType" runat="server" RepeatDirection="Horizontal">
                          <asp:ListItem Value="0" Selected="True">Bill Date Wise</asp:ListItem>
                          <asp:ListItem Value ="1">Admission Date Wise</asp:ListItem>
                          <asp:ListItem Value="2">Currently Admitted</asp:ListItem>
                      </asp:RadioButtonList>
                    </div>
                         <div class="col-md-3">
                        <label class="pull-left">
                            As On Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                          <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ></asp:TextBox>
                                               <cc1:CalendarExtender ID="calucDate" runat="server"  Format="dd-MMM-yyyy" TargetControlID="ucFromDate"></cc1:CalendarExtender>
                    </div>
</div>
                  
                    <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">
                            Search By Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-13"><input type="text" id="Text3" onkeyup="SearchCheckbox(this,'#chlPanel')" data-title="Enter Panel Name" placeholder="Enter The Panel Name" /></div>
                         <div class="col-md-3">
                        <label class="pull-left">
                           Credit Days
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5"> <asp:TextBox ID="txtDays" runat="server" ></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbeFromAge" runat="server" TargetControlID="txtDays" FilterType="Numbers,Custom" /></div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">
                            <asp:CheckBox ID="chkPanel" runat="server" Text="Panels"   CssClass="ItDoseCheckbox" />
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-21">
                          <asp:CheckBoxList ID="chlPanel" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                    CssClass="ItDoseCheckboxlist">
                                </asp:CheckBoxList></div>
                    </div>
                </div>
            <div class="col-md-1"></div></div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton"
                 OnClick="btnReport_Click"  ClientIDMode="Static"/>
            </div>
        
    </div>

</asp:Content>

