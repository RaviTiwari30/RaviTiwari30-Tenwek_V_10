<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BabyGrowthForm.aspx.cs" Inherits="Design_IPD_BabyGrowthForm" %>



<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>


    <style type="text/css">
        .auto-style4 {
            width: 91px;
            height: 16px;
        }

        .auto-style5 {
            width: 456px;
            height: 16px;
        }

        .auto-style7 {
            font-size: 8pt;
        }

        .auto-style8 {
            width: 91px;
        }

        .auto-style9 {
            width: 456px;
        }

        .auto-style10 {
            width: 62px;
        }
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <form id="form1" runat="server">
        <script type="text/javascript">
            if ($.browser.msie) {
                $(document).on("keydown", function (e) {
                    var doPrevent;
                    if (e.keyCode == 8) {
                        var d = e.srcElement || e.target;
                        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                            doPrevent = d.readOnly
                                || d.disabled;
                        }
                        else
                            doPrevent = true;
                    }
                    else
                        doPrevent = false;
                    if (doPrevent) {
                        e.preventDefault();
                    }
                });
            }


        </script>
        <script type="text/javascript">


            function note1() {

                if ($.trim($("#<%=txtWeight.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Weight');
                    $("#<%=txtWeight.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtLength.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Length');
                    $("#<%=txtLength.ClientID%>").focus();
                    return false;
                }
                
                __doPostBack('btnUpdate', '');

            }

            function note() {

                if ($.trim($("#<%=txtWeight.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Weight');
                    $("#<%=txtWeight.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtLength.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Length');
                    $("#<%=txtLength.ClientID%>").focus();
                    return false;
                }
                
                __doPostBack('Btnsave', '');

            }
            
            $(function () {
                           });
        </script>



        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Baby Growth Form </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Baby Growth Chart
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" ReadOnly="true" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <br />
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            </div>
                            </div>
                            <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Weight
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtWeight" CssClass="requiredField" runat="server" Width="70px"></asp:TextBox>
                                <span class="auto-style7">Kg.</span>
                            </div>
                        
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Length
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtLength" CssClass="requiredField" runat="server" Width="70px"></asp:TextBox>
                                <span class="auto-style7">cm.</span>
                            </div>
                            <div class="col-md-3">
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Button ID="Btnsave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton" OnClientClick="return note();" />
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return note1();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
                <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" Visible="false" />
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px;">
                    Results
                </div>
                <table id="tbNursingprogress" style="width:100%;">
                    <tr>
                        <td>
                            <div style="text-align: center;">
                                <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="true" PagerSettings-PageButtonCount="5">

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lbldate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Weight(gm)">
                                            <ItemTemplate>
                                                <asp:Label ID="lblWeight" runat="server" Text='<%# Eval("Weight") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Length (cm)">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLength" runat="server" Text='<%#Eval("Length") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Entry By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCreatedBy" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                                </asp:GridView>
                            </div>

                        </td>
                    </tr>
                </table>
            </div>
             <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Weight Chart</div>
                <asp:Chart ID="chartWeight" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">
                    
                    <Legends>

                        <asp:Legend Name="DefaultLegend" Docking="Top" />

                    </Legends>
                    <Series>
                        <asp:Series ChartType="FastLine" Name="Weight" >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
             <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Length Chart</div>
                <asp:Chart ID="chartLength" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">
                    
                    <Legends>

                        <asp:Legend Name="DefaultLegend" Docking="Top" />

                    </Legends>
                    <Series>
                        <asp:Series ChartType="FastLine" Name="Length" >
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>

            </div>
            
        </div>
    </form>

</body>
</html>

