<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ViewAppointment.aspx.cs" Inherits="Design_OPD_ViewAppointment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
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
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtAppointmentDateFrom').val() + '",DateTo:"' + $('#txtAppointmentdateTo').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#<%=grdAppointment.ClientID%>").hide();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                        $("#<%=grdAppointment.ClientID%>").show();
                    }
                }
            });
        }

    </script>
    <div id="Pbody_box_inventory" style="text-align: left;">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Search Appointment</b><br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static"/>
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div>
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">&nbsp;From Appointment Date :
                        </td>
                        <td>
                            <asp:TextBox ID="txtAppointmentDateFrom" runat="server" 
                                ToolTip="Click To Select From Appointment Date" Width="129px" TabIndex="1"
                                 ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtAppointmentDateFrom_CalendarExtender" runat="server"
                                TargetControlID="txtAppointmentDateFrom" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right">To Appointment Date :
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtAppointmentdateTo" runat="server" 
                                ToolTip="Click To Select To Appointment Date" Width="129px" TabIndex="2"
                                 ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtAppointmentdateTo_CalendarExtender" runat="server" TargetControlID="txtAppointmentdateTo"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right">First Name :
                        </td>
                        <td>
                            <asp:TextBox ID="txtPFirstName" Width="129px" runat="server" TabIndex="1" MaxLength="20"
                                ToolTip="Enter Name"></asp:TextBox>
                        </td>
                        <td style="text-align: right">Last Name :
                        </td>
                        <td>
                            <asp:TextBox ID="txtPLastname" Width="129px" runat="server" TabIndex="1" MaxLength="20"
                                ToolTip="Enter Name"></asp:TextBox>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right">&nbsp;
                        </td>
                        <td colspan="2" style="text-align: center">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                                TabIndex="7" CssClass="ItDoseButton" ClientIDMode="Static" ToolTip="Click To Search" />
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
            <div class="Purchaseheader" style="color: #663300">
                Appointment Details
            </div>
            <div>
                <asp:Panel ID="Panel1" runat="server" Height="300px" ScrollBars="Vertical">
                    <asp:GridView ID="grdAppointment" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        Width="950px">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="AppNo" HeaderText="App No.">
                                <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Patient Name">
                                <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                <ItemStyle CssClass="GridViewItemStyle" Width="180px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VisitType" HeaderText="Visit Type">
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AppTime" HeaderText="App Time">
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <%--<asp:BoundField DataField="AppDate" HeaderText="App Date">--%>
                            <asp:BoundField DataField="AppDate" HeaderText="Reg. Date">
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ConformDate" Visible="false" HeaderText="Confirm Date">
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>


                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
