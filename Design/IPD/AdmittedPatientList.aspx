<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdmittedPatientList.aspx.cs"
     Inherits="Design_IPD_AdmittedPatientList" MasterPageFile="~/DefaultHome.master" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" language="javascript">
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
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lstItems.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<%=txtSearchByName.ClientID %>').keyup(function (e) {
                searchByInBetween("", "", document.getElementById('<%=txtSearchByName.ClientID%>'), document.getElementById('<%=lstItems.ClientID%>'), "", values, keys, e)
            });
        });
        function selectDeselect(listbox, checkbox) {
            var select_all = $(checkbox).prop('checked') ? true : false;
            var select = $(listbox);
            if (select_all) {
                var clone = select.clone();
                $('option', clone).attr('selected', select_all);
                var html = clone.html();
                select.html(html);
            }
            else {
                $('option', select).removeAttr('selected');
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 100%">
        <div class="POuter_Box_Inventory" style="width: 100%">
            <div style="text-align: center;">
                <b>Admitted Patient List</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 100%">
            <div class="Purchaseheader">
                Report&nbsp;Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
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
                                Report&nbsp;Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReportType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
                                <asp:ListItem Text="Ward" Value="2" Selected="True" />
                                <asp:ListItem Text="Doctor" Value="3" />
                                <%--<asp:ListItem Text="Date Wise" Value="4" />--%>
                                <asp:ListItem Text="Department" Value="5" />
                                <%--<asp:ListItem Text="Floor Wise" Value="6" />--%>
                                <asp:ListItem Text="Panel" Value="7" />
                                <asp:ListItem Text="ALL" Value="1" />
                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:DropDownList ID="ddlPanelGroup" runat="server"
                                AutoPostBack="True"
                                OnSelectedIndexChanged="ddlPanelGroup_SelectedIndexChanged" Visible="False">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearchByName" runat="server" ClientIDMode="Static"></asp:TextBox>
                        </div>

                        <div class="col-md-2">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-2">
                            <asp:Button ID="btnPatList" runat="server" Style="margin-top: 0px;" Text="Patient List" OnClick="btnPatList_Click"
                                CssClass="ItDoseButton" />
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" runat="server" Style="margin-top: 0px;" Text="Report" OnClick="btnSearch_Click"
                                CssClass="ItDoseButton" />
                        </div>
                        <div class="col-md-10"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table>
                <tr>
                    <td style="width: 17%; text-align: right">Select All<input type="checkbox" value="Select All" id="chkall" onclick="selectDeselect(lstItems, chkall)" /></td>
                    <td colspan="3" style="width: 50%;" valign="top">
                        <asp:ListBox ID="lstItems" runat="server" CssClass="ItDoseDropdownbox" Height="132px" ClientIDMode="Static"
                            Rows="6" SelectionMode="Multiple" Width="670px"></asp:ListBox>
                    </td>
                    <td colspan="1" style="width: 35%" valign="bottom">
                        <asp:Button ID="btnShow" runat="server" Text="Show & Edit Advance List" CssClass="ItDoseButton"
                            OnClick="btnShow_Click" Width="185px" />
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td colspan="5" style="width: 10%">
                        <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPatient_RowCommand" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="S.NO">
                                     <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                     <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="CentreName" HeaderText="Centre Name" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPName" runat="server" Text='<%# Eval("PatientName")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Age/Sex">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblAge" runat="server" Text='<%# Eval("Age")+"/"+ Eval("Gender") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="BedCategory" HeaderText="Case Type">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <%-- <asp:BoundField  HeaderText="Bed No. ">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                     <ItemTemplate>
                                        <asp:Label ID="lblbed" runat="server" Text='<%# Eval("Age")+"/"+ Eval("Gender") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="Bed No.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblBad" runat="server" Text='<%# Eval("Floor")+"/"+ Eval("RoomName") +"/"+ Eval("Room_No")+"/"+ Eval("BedNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Admit Date">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lbldate" runat="server" Text='<%#  Util.GetDateTime(Eval("DateOfAdmit")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Admitted By" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblAdmittedBy" runat="server" Text='<%#Eval("AdmittedBy") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ConsultantName" HeaderText="Doctor Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="IPD No. ">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblTransactionID" runat="server" Text='<%#Eval("TransNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID ">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRNo" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>


                                <asp:TemplateField HeaderText="Contact No.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblContact" runat="server" Text='<%#  Eval("Mobile") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>


                                <asp:BoundField DataField="Company_Name" HeaderText="Panel">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>

                                <asp:BoundField DataField="BillAmt" HeaderText="Bill Amt.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="Approval" HeaderText="Panel Approval">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Deposit" HeaderText="Deposit">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BanlaneAmt" HeaderText="Balance">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Adv. Request">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtBal" runat="server" Text='<%# Eval("Balance") %>' Width="86px" MaxLength="10"></asp:TextBox>
                                        <%--<cc1:FilteredTextBoxExtender ID="ftbBal" runat="server" TargetControlID="txtBal" FilterType="Numbers"></cc1:FilteredTextBoxExtender>--%>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remarks">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    <ItemTemplate>
                                        &nbsp;<asp:TextBox ID="txtRemarks" runat="server" Text='<%# Eval("Remarks") %>' Width="214px" MaxLength="50"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Select" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chkbxslctal" runat="server" title="Select" width="50px" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="chkSelect" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Send Sms" Visible="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                    <ItemTemplate>

                                        <asp:Label ID="lblDoctorID" Visible="false" runat="server" Text='<%# Eval("DoctorID") %>'></asp:Label>
                                        <asp:Label ID="lblAge1" Visible="false" runat="server" Text='<%# Eval("Age") %>'></asp:Label>
                                        <asp:Label ID="lblGender" Visible="false" runat="server" Text='<%# Eval("Gender") %>'></asp:Label>
                                        <asp:Label ID="lblPName1" runat="server" Visible="false" Text='<%# Eval("PatientName")%>'></asp:Label>
                                        <asp:ImageButton ID="imbSendSms" ToolTip="Send SMS" runat="server" ImageUrl="~/Images/login.png"
                                            CausesValidation="false" CommandName="SendSMS" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("PatientName")+"#"+ Eval("Gender")+"#"+ Eval("Age")+"#"+ Eval("PatientID")+"#"+ Eval("DoctorID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%"></td>
                    <td style="width: 30%;">&nbsp;</td>
                    <td style="width: 10%">&nbsp;</td>
                    <td style="width: 15%"></td>
                    <td style="width: 35%">
                        <asp:Button ID="btnAdvaListReport" runat="server" Text="Advance List" CssClass="ItDoseButton"
                            Visible="False" OnClick="btnAdvaListReport_Click" />
                        <asp:Button ID="btnSendSMS" runat="server" Text="Send Selected SMS" CssClass="ItDoseButton"
                            Visible="False" OnClick="btnSendSMS_Click" />
                        <asp:Button ID="btnExportExcel" runat="server" Text="Export To Excel" CssClass="ItDoseButton"
                            Visible="False" OnClick="btnExportExcel_Click" /></td>

                </tr>
            </table>
        </div>
    </div>


    <script type="text/javascript">
        $(document).ready(function () {
            $("#ctl00_ContentPlaceHolder1_grdPatient_ctl01_chkbxslctal").click(function () {
                $(":checkbox").attr('checked', this.checked);


            });
        });
    </script>

</asp:Content>
