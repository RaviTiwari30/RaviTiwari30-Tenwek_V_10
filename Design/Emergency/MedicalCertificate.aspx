<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicalCertificate.aspx.cs" Inherits="Design_Emergency_MedicalCertificate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
      <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        $(function () {
            $("#ddlDoctor").chosen();
        });
    </script>

    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Medical Certificate</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
      <div class="POuter_Box_Inventory" id="divptdetail" runat="server">
            <div class="Purchaseheader">
                Patient Details:
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        UHID 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtmr" runat="server" Enabled="false"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtptname" runat="server" Enabled="false"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Age/Sex
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtage" runat="server" CssClass="ItDoseTextinputText" Enabled="false" Width="74px"></asp:TextBox>&nbsp;
                            <asp:TextBox ID="txtgender" runat="server" Enabled="false" Width="165px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Relationship
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtrelation" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            From Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtfrmdate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="13"></asp:TextBox>
                        <cc1:CalendarExtender ID="cc3" runat="server" TargetControlID="txtfrmdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            To Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" ClientIDMode="Static" TabIndex="13"></asp:TextBox>
                        <cc1:CalendarExtender ID="cc4" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Address
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Height="52px"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Diagnosis
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtdiagnosis" runat="server" TextMode="MultiLine" Height="52px"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Remarks
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Height="57px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Doctor
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                         <asp:DropDownList ID="ddlDoctor" runat="server" ClientIDMode="Static" ></asp:DropDownList>
                       <%-- <asp:TextBox ID="txtdoctorname" runat="server"></asp:TextBox>--%>
                    </div>
                    <div class="col-md-3" style="display: none">
                        <label class="pull-left">
                            Signature
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" style="display: none">
                        <asp:TextBox ID="txtdrsign" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3" style="display: none">
                        <label class="pull-left">
                            Department
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" style="display: none">
                        <asp:TextBox ID="txtdocdept" runat="server"></asp:TextBox>
                    </div>
                </div>


                <div style="text-align: center">
                    <asp:Button ID="txtsave" runat="server" Text="Save" OnClick="txtsave_Click" />&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnPrint" runat="server" Text="Print" OnClick="btnPrint_Click" Visible="false" />
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px;">
                    Medical Certificate List
                </div>
                <asp:GridView ID="grdDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdDetails_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>

                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>
                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RelationShip">
                            <ItemTemplate>
                                <asp:Label ID="lblRelationName" runat="server" Text='<%#Eval("RelationName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Gender">
                            <ItemTemplate>
                                <asp:Label ID="lblGender" runat="server" Text='<%#Eval("Gender") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RelationShip">
                            <ItemTemplate>
                                <asp:Label ID="lblAge" runat="server" Text='<%#Eval("Age") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <asp:Label ID="lblAddress" runat="server" Text='<%#Eval("Address") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Diagnosis">
                            <ItemTemplate>
                                <asp:Label ID="lblDiagnosis" runat="server" Text='<%#Eval("Diagnosis") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="From Date">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("FromDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ToDate">
                            <ItemTemplate>
                                <asp:Label ID="lblToDate" runat="server" Text='<%# Eval("ToDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemTemplate>
                                <asp:Label ID="lblRemarks" runat="server" Text='<%#Eval("Remarks") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Doctor">
                            <ItemTemplate>
                                <asp:Label ID="lblDoctorName" runat="server" Text='<%#Eval("DoctorName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EntryBy">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnPrint" AlternateText="Print" CommandName="Print" CommandArgument='<%#Eval("ID")%>' ImageUrl="~/Images/print.gif" runat="server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remove" Visible="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnRemove" AlternateText="Remove" CommandName="Remove" CommandArgument='<%#Eval("ID")%>' ImageUrl="~/Images/Delete.gif" runat="server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
