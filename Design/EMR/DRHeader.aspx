<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DRHeader.aspx.cs" Inherits="Design_EMR_DRHeader" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Discharge Report Header</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        function save() {
            var TID = '<%=Util.GetString(ViewState["TID"])%>';
            if (TID != "") {
                $("#btnSave").prop('disabled', 'disabled');
                $.ajax({
                    type: "POST",
                    data: '{Header:"' + $("#<%=ddlheader.ClientID %> option:selected").text() + '",TID:"' + TID + '"}',
                    url: "Services/EMR.asmx/DRHeader",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#<%=lblMsg.ClientID %> ").text('Record Saved Successfully');
                            $("#btnSave").removeProp('disabled', 'disabled');
                        }

                        else {
                            $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                            $("#btnSave").removeProp('disabled', 'disabled');
                        }
                    },
                    error: function (xhr, status) {
                        $("#<%=lblMsg.ClientID %> ").text('Error occurred, Please contact administrator');
                        $("#btnSave").removeProp('disabled', 'disabled');
                    }

                });
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Discharge Report Header
                        <br />
                </b>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Report Header
                </div>
                <div class="content">
                    <table  style="width: 100%;border-collapse:collapse">
                        <tr>
                            <td  style="width: 15%; text-align:right">Report Header :&nbsp;
                            </td>
                            <td style="width: 85%">
                                <asp:DropDownList ID="ddlheader" runat="server" Width="240px">
                                    <asp:ListItem Text="DISCHARGE SUMMARY" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="TRANSFER SUMMARY" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="DEATH SUMMARY" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="REFERRAL SUMMARY" Value="4"></asp:ListItem>
                                    <%--<asp:ListItem Text="Treatmen Summary" Value="4"></asp:ListItem>--%>
                                    <asp:ListItem Text="LEFT AMA SUMMARY" Value="5"></asp:ListItem>
                                    <asp:ListItem Text="ABSCONDER SUMMARY" Value="8"></asp:ListItem>
                                    <%--<asp:ListItem Text="Discharge On Request Summary" Value="6" ></asp:ListItem>
                                <asp:ListItem Text="Discharge On Persistant Request Summary" Value="7" ></asp:ListItem>
                                    <asp:ListItem Text="DEPARTMENT OF PAEDIATRICS & NEONATOLOGY" Value="7" ></asp:ListItem>
                                     <asp:ListItem Text="DOPR" Value="9"></asp:ListItem>
                                    <asp:ListItem Text="DAMA" Value="10"></asp:ListItem>--%>
                                    <asp:ListItem Text="CASE SUMMARY" Value="11"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td  colspan="2" style="text-align: center; "></td>
                        </tr>
                        <tr>
                            <td  colspan="2" style="text-align: left"></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

               
                <input type="button" id="btnSave" value="Save" class="ItDoseButton"  onclick="save()"/>

            </div>


        </div>
    </form>
</body>
</html>
