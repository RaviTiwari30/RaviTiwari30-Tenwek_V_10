<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapItemComponentMaster.aspx.cs" Inherits="Design_BloodBank_MapItemComponentMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function bindBloodBank() {
            $.ajax({
                url: "Services/BloodBank.asmx/bindBloodBankItem",
                data: '{}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length > 0) {

                        $("#BloodBankOutput").empty();

                        var table = "<table id='tbBloodBank' style='width:100%;' cellspacing='0' rules='all' border='1'><tr > <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th> <th class='GridViewHeaderStyle' style='width:260px;'>Item Name</th><th class='GridViewHeaderStyle' style='width:260px;' scope='col'>Component Name </th><th class='GridViewHeaderStyle' style='width:210px;display:none' scope='col'>ItemID </th></tr><tbody>";
                        for (var i = 0; i < Data.length; i++) {
                            var row = "<tr id='Header'>";
                            row += "<td class='GridViewLabItemStyle' id='tdSno' style='width:20px; '>" + (i + 1) + "</td>";
                            row += "<td class='GridViewLabItemStyle'  id='tdItem' style='width:260px;text-align:center'>" + Data[i].TypeName + "</td>";
                            row += "<td class='GridViewLabItemStyle' align='center' id='tdComponent' style='width:260px;text-align:center'><select id='ddlComponent' style='width:230px'/></td>";
                            row += "<td class='GridViewLabItemStyle' align='center' id='tdComponentID' style='display:none'>" + Data[i].ComponentID + "</td>";
                            row += "<td class='GridViewLabItemStyle' align='center' id='tdItemID' style='width:110px;display:none'>" + Data[i].ItemID + "</td>";
                            row += "</tr>";
                            table += row;
                        }
                        table += "</tbody></table>";



                        $("#BloodBankOutput").append(table);
                        $("#tbBloodBank tr").each(function () {
                            var id = $(this).closest("tr").attr("id");
                            var $rowid = $(this).closest("tr");
                            var Sno = $rowid.find("#tdSno").text();
                            if (Sno != "") {
                                var component = $(this).find("#ddlComponent");
                                var componentID = $.trim($(this).find("#tdComponentID").text());
                                $.ajax({
                                    url: "Services/BloodBank.asmx/bindComponentName",
                                    data: '{}',
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    timeout: 120000,
                                    dataType: "json",
                                    async: false,
                                    success: function (result) {
                                        Data = jQuery.parseJSON(result.d);
                                        if (Data.length > 0) {

                                            for (var i = 0; i < Data.length; i++) {
                                                component.append($("<option></option>").val(Data[i].ID).html(Data[i].ComponentName));
                                            }
                                            component.val(componentID);
                                        }

                                    }

                                });

                            }
                        });

                    }

                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        $(document).ready(function () {

            bindBloodBank();
        });

        function saveItem() {
            $("#btnSave").prop('disabled', 'disabled');
            var dataBloodbank = new Array();
            var ObjBloodbank = new Object();
            $("#tbBloodBank tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                var Sno = $rowid.find("#tdSno").text();
                if (Sno != "") {
                    ObjBloodbank.ItemID = $rowid.find("#tdItemID").text();
                    ObjBloodbank.ComponentID = $.trim($rowid.find("#ddlComponent").val());
                    dataBloodbank.push(ObjBloodbank);
                    ObjBloodbank = new Object();
                }

            });
            if (dataBloodbank.length > 0) {
                $.ajax({
                    url: "Services/BloodBank.asmx/saveItemComponent",
                    data: JSON.stringify({ Bloodbank: dataBloodbank }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            DisplayMsg('MM01', 'lblErrormsg');
                        }
                        else {
                            DisplayMsg('MM05', 'lblErrormsg');
                        }
                        $("#btnSave").removeProp('disabled');
                    },

                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#btnSave").removeProp('disabled');
                    }

                });
            }
            $("#btnSave").removeProp('disabled');
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Map Item With Component</b><br />
            <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
        <table style="width: 100%;">
            <tr>
                <td style="text-align: center" >
                    
                    <div id="BloodBankOutput" style="max-height: 600px; overflow-x: auto;">
                    </div>

                </td>

            </tr>
        </table>
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave save" style="margin-top:7px" onclick="saveItem()"  value="Save" />
        </div>
    </div>
</asp:Content>

