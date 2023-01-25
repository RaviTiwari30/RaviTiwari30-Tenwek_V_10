<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary_ProvisionalFinalDiagnosis.aspx.cs" Inherits="Design_Mortuary_Mortuary_ProvisionalFinalDiagnosis" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
  <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
        <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
      <script type="text/javascript" src="../../Scripts/Message.js"></script>

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
    <style type="text/css">
        .accordion
        {
        }

        .accordionHeader
        {
            border: 1px solid #2F4F4F;
            color: Black;
            background-color: lightsalmon;
            font-family: Arial, Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            padding: 5px;
            margin-top: 5px;
            cursor: pointer;
        }

        .accordionHeaderSelected
        {
            border: 1px solid #2F4F4F;
            color: Black;
            background-color: salmon;
            font-family: Arial, Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            padding: 5px;
            margin-top: 5px;
            cursor: pointer;
        }

        .accordionContent
        {
            background-color: white;
            border: 1px dashed #2F4F4F;
            border-top: none;
            padding: 5px;
            padding-top: 10px;
        }
    </style>
    <script type="text/javascript" language="javascript" src="../../Scripts/Search.js"></script>
    <script src="../../Scripts/jquery-1.7.1.js" type="text/javascript" language="javascript"></script>
    <script type="text/javascript" language="javascript">
        function Blank() {
            $("input[type=text], textarea").val("");
            $('input[type=radio]').prop('checked', false);
            $('input[type=checkbox]').prop('checked', false);
        }
        $(document).ready(function () {
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
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnPreview').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnPreview').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>View Diagnosis And Allergy History</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <br />

            <div id="accordion">

                <cc1:Accordion ID="Accordion1" runat="server" CssClass="accordion" HeaderCssClass="accordionHeader"
                    HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent">
                    <Panes>
                        <cc1:AccordionPane ID="AccordionPane1" runat="server">
                            <Header>
                            Provisional Diagnosis</Header>
                            <Content>
                                <asp:GridView ID="grdProvisional" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Provisional Diagnosis">
                                            <ItemTemplate>
                                                <%#Eval("ProvisionalDiagnosis") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Prescribed DateTime">
                                            <ItemTemplate>
                                                <%#Eval("Date") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                        <cc1:AccordionPane ID="AccordionPane3" runat="server">
                            <Header>
                            Final Diagnosis</Header>
                            <Content>
                                <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Group Desc">
                                            <ItemTemplate>
                                                <%#Eval("Group_Desc") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Name Desc">
                                            <ItemTemplate>
                                                <%#Eval("ICD10_3_Code_Desc") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="WHO Full Desc">
                                            <ItemTemplate>
                                                <%#Eval("WHO_Full_Desc") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                        <cc1:AccordionPane ID="AccordionPane2" runat="server">
                            <Header>
                            Alergies</Header>
                            <Content>
                                <asp:GridView ID="grdAllergies" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Allergies">
                                            <ItemTemplate>
                                                <%#Eval("Allergies") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                    </Panes>
                </cc1:Accordion>
            </div>
        </div>
    </form>
    <asp:Label ID="lblPatientID" runat="server" Style="display: none;"></asp:Label>    
</body>
</html>
