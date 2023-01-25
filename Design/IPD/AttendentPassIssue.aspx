<%@ Page Language="C#" ValidateRequest="false" ClientIDMode="Static" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="AttendentPassIssue.aspx.cs" Inherits="Design_IPD_AttendentPassIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function validateIPDNo() {
            if (($.trim($("#txtIPDNo").val()) == "") && ($.trim($("#txtMRNo").val()) == "")) {
                $("#lblMsg").text('Please Enter Either IPD No. or UHID');
                $("#txtIPDNo").focus();
                return false;
            }
        }
            function validateVisitorName() {
                if ($.trim($("#txtVisitorName").val()) == "") {
                    $("#lblMsg").text('Please Enter Visitor Name');
                    $("#txtVisitorName").focus();
                    return false;
                }
            }
            $(function () {
                $('input').keyup(function () {
                    if(event.keyCode == 13)
                        if($(this).val() != "")
                            $('#btnSearch').click();
                });
            });
    </script>
    <div id="Pbody_box_inventory">

        <Ajax:ScriptManager ID="sm" runat="server" />
        <Ajax:UpdatePanel ID="up" runat="server">
            <ContentTemplate>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Gate Pass Issue/Submit</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />&nbsp;              
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No. 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static"
                                data-title="Enter IPD No." TabIndex="1" ></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static"
                                data-title="Enter UHID" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-8">
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="3" ClientIDMode="Static"
                        Text="Search" OnClick="btnSearch_Click" OnClientClick="return validateIPDNo()" />
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;" id="divPatientDetail" runat="server" visible="false">
                    <div class="Purchaseheader">
                        Patient Details 
                    </div>
                    <div style="overflow: auto; padding: 3px; max-height: 50px;">
                        <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False"
                            CssClass="GridViewStyle" OnRowCommand="grdPatient_RowCommand" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="IPD No.">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblIPDNo" Visible="false" Text='<%#Util.GetString(Eval("TransactionID")) %>' runat="server"></asp:Label>
                                        <asp:Label ID="Label1" Text='<%#Util.GetString(Eval("TransNo")) %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRNo" Text='<%#Eval("PatientID") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Name">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPName" Text='<%# Eval("PName") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Address" HeaderText="Address">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Ward Name">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Bed_No" HeaderText="Bed No.">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="View">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgPass" ToolTip="Pass" runat="server" ImageUrl="~/Images/view.GIF" TabIndex="4" CausesValidation="false" CommandArgument='<%# Eval("TransactionID") %>' CommandName="Pass" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </div>
                </div>

                <div class="POuter_Box_Inventory" id="divAttendentDetail" runat="server" visible="false">
                    <div class="row">
                        <div class="col-md-1">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Visitor Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtVisitorName" ClientIDMode="Static" runat="server" CssClass="requiredField" AutoCompleteType="Disabled" MaxLength="90" ToolTip="Enter Visitor Name" TabIndex="5"></asp:TextBox>
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnIssue" runat="server" CssClass="ItDoseButton" OnClientClick="return validateVisitorName()" TabIndex="6" Text="Issue" OnClick="btnIssue_Click" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>

                  <div class="POuter_Box_Inventory" id="divVisitorIssuedDetail" runat="server" visible="false">
                       <div class="Purchaseheader">
                        Visitor Pass Issue Details 
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <div style="overflow: auto; padding: 3px; max-height: 350px;">
                            <asp:GridView ID="grdVisitorDetails" runat="server" AutoGenerateColumns="False" Width="100%"
                            CssClass="GridViewStyle" OnRowCommand="grdVisitorDetails_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="SR No.">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle"  Width="50px" />
                                    <ItemTemplate>
                                       <%# Container.DataItemIndex +1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                               
                                <asp:BoundField DataField="VisitorID" HeaderText="Visitor No.">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="VisitorName" HeaderText="Visitor Name">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="IssueDate" HeaderText="IssueDate">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="IssueBy" HeaderText="Issue By">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Status" HeaderText="Status">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                 <asp:TemplateField HeaderText="Print">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgPrint" ToolTip="Submit" runat="server" Visible='<%# Util.GetBoolean(Eval("IsSubmitShow")) %>' ImageUrl="~/Images/Post.gif" TabIndex="7" CausesValidation="false" CommandArgument='<%# Eval("VisitorID") +"#"+  Eval("VisitorName") +"#"+ Eval("TransactionID") %>' CommandName="Print" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Submit">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgSubmit" ToolTip="Submit" runat="server" Visible='<%# Util.GetBoolean(Eval("IsSubmitShow")) %>' ImageUrl="~/Images/Post.gif" TabIndex="7" CausesValidation="false" CommandArgument='<%# Eval("ID") +"#"+ Eval("TransactionID") %>' CommandName="Submit" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                                </div>
                        </div>
                    </div>
                </div>

            </ContentTemplate>
        </Ajax:UpdatePanel>
    </div>

</asp:Content>
