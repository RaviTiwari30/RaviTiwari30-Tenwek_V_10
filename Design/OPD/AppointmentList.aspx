<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AppointmentList.aspx.cs" Inherits="Design_OPD_AppintmentList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        $(function () {               
            $('#txtAppointmentDateFrom').change(function () {
                ChkDate();
            });
            $('#txtAppointmentdateTo').change(function () {
                ChkDate();
            });
        });
     function ChkDate() {
         $.ajax({
             url: "../Common/CommonService.asmx/CompareDate",
             data: '{DateFrom:"' + $('#txtAppointmentDateFrom').val() + '",DateTo:"' + $('#txtAppointmentdateTo').val() + '"}',
             type: "POST",
             async: true,
             dataType: "json",
             contentType: "application/json; charset=utf-8",
             success: function (mydata) {
                 var data = mydata.d;
                 if (data == false) {
                     $('#lblMsg').text('To date can not be less than from date!');
                     $('#btnSearch').prop('disabled', 'disabled');
                     $("#tbAppointment table").remove();

                 }
                 else {
                     $('#lblMsg').text('');
                     $('#btnSearch').removeProp('disabled');
                 }
             }
         });

     }

    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Appointment List</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style=" width:100%;border-collapse:collapse">
                <tr>
                    <td style="text-align: right; width: 20%">From Appointment Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtAppointmentDateFrom" runat="server"
                            ToolTip="Click To Select From Appointment Date" Width="130px" TabIndex="1"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtAppointmentDateFrom_CalendarExtender" runat="server"
                            TargetControlID="txtAppointmentDateFrom" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">To Appointment Date :&nbsp;
                    </td>
                    <td style="text-align: left;width: 30%">
                        <asp:TextBox ID="txtAppointmentdateTo" runat="server"
                            ToolTip="Click To Select To Appointment Date" Width="130px" TabIndex="2"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtAppointmentdateTo_CalendarExtender" runat="server" TargetControlID="txtAppointmentdateTo"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">Doctor Name :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:DropDownList ID="ddlDoctor" runat="server" TabIndex="3"
                            ToolTip="Select Doctor" Width="136px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 20%; text-align: right">&nbsp;
                    </td>
                    <td style="text-align: left;width: 30%">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <asp:Button ID="btnSearch" runat="server" Text="Search"
                            OnClick="btnSearch_Click" ClientIDMode="Static" TabIndex="4"
                            ToolTip="Click To search" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
                        <table style="width:100%;text-align: center">
                            <tr>
                                <td style="width: 250px;"></td>
                                <td style="background-color:white;width: 30px; height: 8px;text-align:right"></td>
                                <td style="text-align:left">Not-Registered</td>
                                 <td style="background-color: LimeGreen;width: 30px; height: 8px;"></td>
                                <td style="text-align: left">Registered</td>
                         
                            <td style="background-color: LightBlue; width: 20px; height: 8px;"></td>
                                    <td style="text-align: left;">Payment Received</td>
                                <td style="width: 150px;"></td>
                            </tr>

                        </table>


        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Result
            </div>
            <table id="tbAppointment">
                <tr>
                    <td>
                        <asp:GridView ID="grdAppointment" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdAppointment_RowCommand"
                            OnRowDataBound="grdAppointment_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                                        <asp:Label ID="lblLedgerTnxNo" runat="server" Text='<%#Eval("LedgerTnxNo") %>' Visible="false"></asp:Label>

                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="110px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="App_ID" HeaderText="AppID" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AppNo" HeaderText="App. No.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Patient Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="VisitType" HeaderText="Patient Type" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AppTime" HeaderText="App. Time">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="70px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AppDate" HeaderText="App. Date">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="84px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="84px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ConformDate" Visible="false" HeaderText="Confirm Date">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Registration" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" >
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                                    <ItemTemplate>
                                        <asp:Button ID="btnRegistration" runat="server" Text="Registration" CommandName="Registration"
                                            CommandArgument='<%# Eval("App_ID")%>' CssClass="ItDoseButton" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Get Payment" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="80px" />
                                    <ItemTemplate>
                                        <asp:Button ID="btnPayment" CssClass="ItDoseButton" runat="server" Text="Get Payment" CommandName="GetPayment"
                                            CommandArgument='<%# Eval("App_ID")+"#"+Eval("PatientID")+"#"+Eval("DoctorID")%>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                     <ItemTemplate>
                                        <asp:ImageButton ID="imbView" ToolTip=" Appointment Slip" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("App_ID")%>' CommandName="Print" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                             
                                 <asp:TemplateField HeaderText="Labels">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgbtnSticker" ToolTip="Sticker" runat="server" ImageUrl="../../Images/view.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("TransactionID")%>' CommandName="Sticker" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>

        </div>
    </div>
</asp:Content>
