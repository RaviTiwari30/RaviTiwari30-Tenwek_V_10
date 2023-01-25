<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ManageApproval.aspx.cs" Inherits="Design_Investigation_ManageApproval" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        function hideme() {
            if ($('#<%=chisdefault.ClientID%>').is(":checked")) {
                $('#trshow').hide();
            }
            else {
                $('#trshow').show();
            }
        }

        function alertDelete() {
            //var answer = confirm("Are you sure to remove Approval right?")
            //if (answer) {
            //    return true;
            //}
            //else
                return true;
        }

        $(document).ready(function () {
            bindGrid();
        });
        function bindGrid() {
            $('#tb_ItemList tr').slice(1).remove();
            // $.blockUI();
            $.ajax({
                url: "ManageApproval.aspx/bindgrid",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    AllData = $.parseJSON(result.d);
                    if (AllData.length == 0) {
                        // $.unblockUI();
                        //showerrormsg("Record Not Found..!");
                        modelAlert('Record Not Found');
                        return false;
                    }
                    else {
                        for (var i = 0; i <= AllData.length - 1; i++) {
                            var mydata = "<tr>";
                            mydata += "<td>" + (i + 1) + "</td>";
                            mydata += "<td align='left'>" + AllData[i].Rolename + "</td>";
                            mydata += "<td align='left'>" + AllData[i].empName + "</td>";
                            mydata += "<td align='left'>" + AllData[i].TechName + "</td>";
                            mydata += "<td align='left'>" + AllData[i].Authority + "</td>";
                            mydata += "<td align='left'>" + AllData[i].DefaultSignature + "</td>";
                            mydata += "<td><img src='../../Images/Delete.gif' style='cursor:pointer' onclick='removeSign(this.id)' id='" + AllData[i].id + "' /></td>";
                            mydata += "<td><img src='../../Images/view.gif' style='cursor:pointer' onclick='ShowSign(this.id)' id='" + AllData[i].EmployeeID + "' /></td>";
                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);
                        }
                        //  $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                    modelAlert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                    //  $.unblockUI();
                }
            });
        }

        function removeSign(removalID) {
            //var answer = modelAlert("Are you sure to remove Approval right?")
            var answer = true;
            if (answer) {
                //  $.blockUI();
                $.ajax({
                    url: "ManageApproval.aspx/removeSign",
                    data: JSON.stringify({ ID: removalID }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == '1') { 
                            modelAlert('Record Removed Successfully', function (response) {
                                bindGrid();
                            });
                        }
                        else { 
                            modelAlert('Record Not Removed', function (response) {
                                bindGrid();
                            });
                        }

                    },
                    error: function (xhr, status) {
                        modelAlert(status + "\r\n" + xhr.responseText);
                        window.status = status + "\r\n" + xhr.responseText;
                        //  $.unblockUI();
                    }
                });
            }
            else {
                return false;
            }
        }
        function ShowSign(imgID) {
            var urlimg = "../Lab/Signature/" + imgID + ".jpg";
            $("#popUpImage").dialog({
                resizable: false,
                height: 250,
                width: 1000,
                modal: true,
                draggable: false,
                open: function () {
                    document.getElementById('imgsh').src = urlimg;
                    document.getElementById('imgsh').style.display = 'block';
                },
                show: {
                    effect: 'fade',
                    duration: 100
                },
                hide: {
                    effect: 'fade',
                    duration: 100
                },
                buttons: {
                    "Close": function () {
                        $(this).dialog("close");
                    }
                }
            });
        }
    </script>

    <style>
        .ui-widget-header, .ui-state-default, ui-button {
            background: #800080;
            border: 1px solid #b9cd6d;
            color: #FFFFFF;
            font-weight: bold;
            font-size: 13pt;
        }

        .ui-dialog-titlebar-close {
            visibility: hidden;
        }

        .ui-widget-overlay {
            background: #AAA url(images/ui-bg_flat_0_aaaaaa_40x100.png) 50% 50% repeat-x;
            opacity: .60;
            filter: Alpha(Opacity=30);
        }

        .ui-dialog-buttonpane {
            border: 0;
            height: 0px;
        }
    </style>




    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <strong>Manage Approval<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="Purchaseheader">
                    Select Approval
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
                    <asp:DropDownList ID="ddlEmployee" runat="server" Width="200px"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Technician
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlTecnicianID" runat="server" Width="200px">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Login Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="DDroleid" runat="server" Width="200px"></asp:DropDownList>
                </div>
                <div style="display: none;">
                    <asp:CheckBox ID="chisdefault" runat="server" Style="font-weight: 700; display: none" Text="Default Signature" onclick="hideme()" />
                </div> 
            </div>
             <div class="row" id="trshow">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Signature
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <div class="col-md-15">
                            <asp:FileUpload ID="fuSign" runat="server" />
                        </div>
                        <div class="col-md-7">
                           <strong> (Optional)</strong>
                        </div>
                    </div>
                </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        For Approval
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-20">
                    <asp:RadioButtonList ID="rblApproval" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Selected="True" Value="1">Approve</asp:ListItem>
                        <asp:ListItem Value="2">Forward</asp:ListItem>
                        <asp:ListItem Value="3">Approve & NotApprove</asp:ListItem>
                        <asp:ListItem Value="4">Approve & NotApprove & Unhold</asp:ListItem>
                        <asp:ListItem Value="5">Result Entry</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="row" align="center">
                <asp:Button ID="Button1" runat="server"  OnClick="Button1_Click" Text="Add" />
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                All Selected Approval
            </div>
            <div id="popUpImage" title="Uploaded Image Preview" style="text-align: center; display: none;">
                <img id="imgsh" alt="Image Not Available" />
            </div>


            <div>
                <table style="width: 100%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" width="20px" style="text-align: center;">Sr.No</td>
                        <td class="GridViewHeaderStyle" width="90px" style="text-align: left;">RoleName</td>
                        <td class="GridViewHeaderStyle" width="140px" style="text-align: left;">Employee Name</td>
                        <td class="GridViewHeaderStyle" width="100px" style="text-align: left;">Technician Name</td>
                        <td class="GridViewHeaderStyle" width="160px" style="text-align: left;">Authority</td>
                        <td class="GridViewHeaderStyle" width="50px" style="text-align: left;">Default Signature</td>

                        <td class="GridViewHeaderStyle" width="50px" style="text-align: center;">Delete</td>
                        <td class="GridViewHeaderStyle" width="50px" style="text-align: center;">View Signature</td>
                    </tr>
                </table>
            </div>


        </div>
    </div>


</asp:Content>
