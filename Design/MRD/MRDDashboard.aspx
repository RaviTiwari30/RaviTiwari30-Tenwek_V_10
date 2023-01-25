<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MRDDashboard.aspx.cs" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_MRD_MRDDashboard" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#ucDateFrom').change(function () {
                ChkDate();

            });

            $('#ucDateTo').change(function () {
                ChkDate();

            });

        });



        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDateFrom').val() + '",DateTo:"' + $('#ucDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnissue.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnissue.ClientID %>').removeAttr('disabled');
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

    </script>

    <div>
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager2" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory">
                <div class="">
                    <div style="text-align: center;">
                        <strong>MRD Reports</strong>
                        <br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center">
                <div class="Purchaseheader">
                    Search Patient&nbsp;
                </div>
                <div class="row" style="text-align:center">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">From Date</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                    TabIndex="1" CssClass="ItDoseTextinputText" Width="120px"></asp:TextBox>
                                <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                                <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="97px" ToolTip="Enter Time"
                                    TabIndex="2" />
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtFromTime" AcceptAMPM="true">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                    InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">To Date</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                    TabIndex="2" CssClass="ItDoseTextinputText" Width="120px"></asp:TextBox>
                                <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucDateTo" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                                <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="97px" ToolTip="Enter Time"
                                    TabIndex="4" />
                                <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtToTime" AcceptAMPM="true">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                    InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                            <div class="col-md-8"><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></div>
                        </div>
                        <div class="row">
                            <div class="col-md-3"><label class="pull-left">UHID</label><b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtUHID" runat="server" ClientIDMode="Static" ToolTip="Enter UHID"
                                    TabIndex="2" CssClass="ItDoseTextinputText" ></asp:TextBox>
                                </div>
                            <div class="col-md-3"><label class="pull-left">IPD No.</label><b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5"> <asp:TextBox ID="txtIPDno" runat="server" ClientIDMode="Static" ToolTip="Enter IPD No"
                                    TabIndex="2" CssClass="ItDoseTextinputText" MaxLength="10" ></asp:TextBox>
                                </div>
                             <div class="col-md-3"></div>
                                  <div class="col-md-5"></div>
                        </div>
                       
                        <div class="row" style="border:groove">
                            <div class="col-md-3" ></div>
                            <div class="col-md-21" >
                                <asp:RadioButtonList ID="rbtnreport" runat="server" Font-Bold="True" Font-Size="8pt"
                                    RepeatDirection="Horizontal" Width="100%" Style="text-align: left;" RepeatColumns="4">
                                    <asp:ListItem Value="1" Selected="True">Patient Master File </asp:ListItem>
                                    <asp:ListItem Value="2">Emergency To IPD Patient Register</asp:ListItem>
                                    
                                    <asp:ListItem Value="4">Currently IP Patient Register</asp:ListItem>
                                    
                                    <asp:ListItem Value="6">HIV Lab Test Register</asp:ListItem>
                                    <asp:ListItem Value="7">Lab Radiology Register</asp:ListItem>
                                    <asp:ListItem Value="8">IPD Patient Register (Hourly)</asp:ListItem>
                                  
                                    <asp:ListItem Value="12">New Emergency Patient Register</asp:ListItem>
                                  
                                    <asp:ListItem Value="14">ChaperOn Services</asp:ListItem>
                               
                                    <asp:ListItem Value="16">Emergency Patient Register</asp:ListItem>
                                    <asp:ListItem Value="17">OP Patient Register</asp:ListItem>
                                    <asp:ListItem Value="18">IP Patient Register</asp:ListItem>
                                    <asp:ListItem Value="19">IP Discharge Register</asp:ListItem>
                                    <asp:ListItem Value="20">Dialysis Register</asp:ListItem>
                                    <asp:ListItem Value="21">Physiotherapy Count Register</asp:ListItem>
                                  
                                    <asp:ListItem Value="23">Current IP Surgery Register</asp:ListItem>
                                 
                                    <asp:ListItem Value="25" >Emergency Hourly Report</asp:ListItem>
                                    <asp:ListItem Value="26" >OP Patient Register (Hourly)</asp:ListItem>
                                    <asp:ListItem Value="27" style="display:none;">ICU Patient Register</asp:ListItem>
                                    <asp:ListItem Value="28" style="display:none;">Day Care Patient Register</asp:ListItem>
                                    <asp:ListItem Value="29" style="display:none;">DAMA Patient Register</asp:ListItem>
                                    <asp:ListItem Value="30" style="display:none;">LAMA Patient Register</asp:ListItem>
                                    <asp:ListItem Value="31" style="display:none;">Monthly Wise Total Occupancy Report</asp:ListItem>
                                    <asp:ListItem Value="32" style="display:none;">AFP Base Report</asp:ListItem>
                                    <asp:ListItem Value="33" style="display:none;">Registration Remarks</asp:ListItem>
                                    <asp:ListItem Value="34" style="display:none;">Audit for Print Report </asp:ListItem>

                                    <asp:ListItem Value="3" style="display:none;">Monthly Report On hospital Act</asp:ListItem>
                                    <asp:ListItem Value="5" style="display:none;">Surgery Register</asp:ListItem>
                                    <asp:ListItem Value="9" style="display:none;">Cath Lab Register</asp:ListItem>
                                    <asp:ListItem Value="10" style="display:none;">Daily Occupancy Report</asp:ListItem>
                                    <asp:ListItem Value="11" style="display:none;">Live Bed Board</asp:ListItem>
                                      <asp:ListItem Value="13"  style="display:none;">Today’s Scheduled Operation</asp:ListItem>
                                         <asp:ListItem Value="15" style="display:none;">Quarterly Wise Hospital Occupancy</asp:ListItem>
                                      <asp:ListItem Value="22" style="display:none;">Gastro Logy Register</asp:ListItem>
                                       <asp:ListItem Value="24" style="display:none;">Monthly Wise Occupancy Register</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row" style="border:groove">
                            <div class="col-md-3">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                            </div>
                            <div class="col-md-21">
                                <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                                </asp:CheckBoxList>
                            </div>
                        </div>
                        <div class="row" style="border:groove">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Report Type
                                </label>
                              <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                                <asp:RadioButtonList ID="rdbreporttype" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="PDF">PDF</asp:ListItem>
                                    <asp:ListItem Value="Excel"  Selected="True">Excel</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <asp:Button ID="btnissue" Text="Report" CssClass="ItDoseButton" runat="server" ClientIDMode="Static"
                                    OnClick="btnissue_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
