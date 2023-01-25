<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="PatientRegSearch.aspx.cs" Inherits="Design_IPD_PatientRegSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="content1" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });

        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdPatient.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
        function ChkDateCon() {
            var status = $('#<%= chkDate.ClientID %>').is(':checked');
            if (status == true)
                $('#<%=txtFromDate.ClientID%>,#<%=txtToDate.ClientID%>').attr("disabled", false);
            else
                $('#<%=txtFromDate.ClientID%>,#<%=txtToDate.ClientID%>').attr("disabled", true);
        }
        $(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13 && $(this).length > 0)
                    $('#btnSearch').click();
            });
        });
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Admitted Patients </b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled"
                                ToolTip="Enter UHID" TabIndex="1" MaxLength="20"></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPfirstname" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" data-title="Enter Patient First Name"
                                MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtplastname" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" data-title="Enter Patient Last Name" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIpdno" runat="server" AutoCompleteType="Disabled"
                                TabIndex="3" data-title="Enter IPD No." MaxLength="10"></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkDate" Visible="false" runat="server" Checked="True" onclick="ChkDateCon()" ClientIDMode="Static" />
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server"
                                TabIndex="6" data-title="Click To Select From Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" TabIndex="7"
                                data-title="Click To Select To Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calTo" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Location
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLocation" runat="server" AutoCompleteType="Disabled"
                                TabIndex="5" data-title="Enter Location" Width="225px" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                City
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCity" runat="server" AutoCompleteType="Disabled"
                                TabIndex="4" data-title="Enter City" Width="225px" MaxLength="50"></asp:TextBox>&nbsp;
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="8" ClientIDMode="Static"
                Text="Search" OnClick="btnSearch_Click" ToolTip="Click To Search" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Patient Details Found
            </div>
            <div style="overflow: auto; padding: 3px; height: 290px;">
                <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" OnRowCommand="grdPatient_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <%-- <asp:BoundField DataField="PatientID" HeaderText="Reg. No.">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:BoundField>--%>
                        <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="lblIPDNo" runat="server" Text='<%#Util.GetString(Eval("IPDNo")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                        <asp:BoundField DataField="PName" HeaderText="Name" Visible="false">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PFirstName" HeaderText="First Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PLastName" HeaderText="Last Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Age" HeaderText="Age">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Phone" HeaderText="Contact No.">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Gender" HeaderText="Sex">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Admission" Visible="False">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbAdmit" ToolTip="Admit Patient" runat="server" ImageUrl="~/Images/login.png"
                                    CausesValidation="False" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID") %>'
                                    CommandName="Admit" Visible='<%# Util.GetBoolean(Eval("AdStatus")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Registration" Visible="False">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbReg" ToolTip="Edit Registration" runat="server" ImageUrl="~/Images/reg.jpg"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")%>' CommandName="EditReg" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            <ItemTemplate>
                                <%--<asp:ImageButton ID="imbEdit" ToolTip="Edit" runat="server" ImageUrl="~/Images/edit.png"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID")%>'
                                    CommandName="EditAd" Enabled='<%# Util.GetBoolean(Eval("EdStatus")) %>' />--%>
                                <asp:ImageButton ID="imbEdit" ToolTip="Edit" runat="server" ImageUrl="~/Images/edit.png"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID")%>'
                                    CommandName="EditAd" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" ToolTip="View Admission Details" runat="server" ImageUrl="~/Images/view.GIF"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID")%>' CommandName="EditView" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
