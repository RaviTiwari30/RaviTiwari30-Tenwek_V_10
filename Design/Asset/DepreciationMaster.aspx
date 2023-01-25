<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="DepreciationMaster.aspx.cs" Inherits="Design_Asset_DepreciationMaster" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">
        $(document).ready(function () {
            loadGroup(function (GroupID) {
                loadItems(GroupID, function () {

                });
            });
        });

        var loadGroup = function (callback) {
            ddlGroup = $('#ddlGroup');
            serverCall('Services/WebService.asmx/loadGroup', {}, function (response) {
                ddlGroup.bindDropDown({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'SubCategoryName', isSearchAble: true });
                callback(ddlGroup.val());
            });
        }
        var loadItems = function (GroupID, callback) {
            Clear();
            serverCall('Services/WebService.asmx/loadItemswithDepriation', { GroupID: GroupID }, function (response) {
                var responseData = JSON.parse(response);
                bindDetail(responseData);
            });
            callback(true);
        }
        var bindDetail = function (data) {
            $('#tbSearch tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbSearch tbody tr').length + 1;  
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdGroupName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SubCategoryName + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="First" placeholder="%" max-value="100" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].First_Per + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Second" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Second_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Third"  placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Third_Per + '"/></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Four" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Fourth_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Five" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Fifth_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Six" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Six_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Seven" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Seventh_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Eight" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Eigth_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Nine" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Nine_Per + '" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" onlynumber="5"  decimalPlace="2"  class="Ten" placeholder="%" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="' + data[i].Ten_Per + '" /></td>';
                row += '<td id="tdSubcategoryID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SubCategoryID + '</td>';
                row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '</tr>';
                $('#tbSearch tbody').append(row);
            }
            
        }

        var fillPer = function (elem) {
            var classname = $(elem).attr('class');
            $table = $('#tbSearch tbody tr');
            var per = $(elem).val().trim();
           
            $($table).each(function (index, row) {
                if (per > 0) {
                    $(row).find('.' + classname).val(per);

                }
                else {
                    $(row).find('.' + classname).val('');
                }
            });
            
        }
        var FindNameinTable = function (elem) {
            var name = $.trim($(elem).val());
            var length = $.trim($(elem).val()).length;

            $('#tbSearch tr').hide();
            $('#tbSearch tr:first').show();
            var searchtype = $('input[type=radio][name=rdoSearchtype]:checked').val();
            if (searchtype == 0) {
                $('#tbSearch tr').find('#tdItemName').filter(function () {
                    if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                        return $(this);
                }).parent('tr').show();;
            }
            else {
                $('#tbSearch tr').find('#tdItemName').filter(function () {
                    if ($(this).text().toLowerCase().match(name.toLowerCase()))
                        return $(this);
                }).parent('tr').show();;
            }
        }

        var Save = function () {
            getDetails(function (data) {
                serverCall('Services/WebService.asmx/SaveItemDepreciationDetail', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        Clear();
                    });
                });
            });
        }
        var getDetails = function (callback) {
            debugger;
            $table = $('#tbSearch tbody tr');
            depreciatian = [];
            $table.each(function (index, row) {
                var validate = 0;
                $(row).find('input[type=text]').filter(function () {if (!String.isNullOrEmpty($(this).val())) {validate = 1; return; }});
                if (validate == 1) {
                    depreciatian.push({
                        SubcategoryID: $(row).find('#tdSubcategoryID').text().trim(),
                        ItemID: $(row).find('#tdItemID').text().trim(),
                        First: Number($(row).find('.First').val()),
                        Second: Number($(row).find('.Second').val()),
                        Third: Number($(row).find('.Third').val()),
                        Four: Number($(row).find('.Four').val()),
                        Five: Number($(row).find('.Five').val()),
                        Six: Number($(row).find('.Six').val()),
                        Seven: Number($(row).find('.Seven').val()),
                        Eigth: Number($(row).find('.Eight').val()),
                        Nine: Number($(row).find('.Nine').val()),
                        Ten: Number($(row).find('.Ten').val()),
                    });
                }
            });
            if (depreciatian.length <= 0) {
                modelAlert('Please Enter Depretiation Percentage');
                return false;
            }
            callback({ depreciatian: depreciatian });
        }
        var Clear = function() {
            $table = $('#tbSearch');
            $table.each(function (index, row) {
                $(row).find('input[type=text]').val('');
            });
        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Depreciation Master</b>
            <span style="display: none" id="spnDepreciationID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Group Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlGroup" class="requiredField" onchange="loadItems(this.value, function () {});"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtName" maxlength="200" placeholder="Search here" onkeyup="FindNameinTable(this)" />
                        </div>
                        <div class="col-md-8">
                            <input type="radio" name="rdoSearchtype" value="0" checked="checked" />Search By First Name
                            <input type="radio" name="rdoSearchtype" value="1" />Search In Between
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory Depdetail">
            <div class="Purchaseheader">
                Enter Depreciation Percentage
            </div>
            <div class="row">
            <div id="divOutput" style="max-height: 480px; overflow-x: auto">
                <table class="FixedHeader" id="tbSearch" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                            <th class="GridViewHeaderStyle" style="width: 120px;">Group Name</th>
                            <th class="GridViewHeaderStyle" style="width: 220px;">Item Name</th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">1st Year<br />
                                <input type="text" onlynumber="5"  decimalPlace="2" max-value="100" placeholder="Enter %" onkeyup="fillPer(this);" class="First" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">2nd Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" max-value="100" placeholder="Enter %" onkeyup="fillPer(this);" class="Second" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">3rd Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Third" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">4th Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Four" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">5th Year<br />
                                <input type="text" onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Five" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" />
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">6th Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Six" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" />
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">7th Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Seven" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">8th Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Eight" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">9th Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Nine" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">10th Year<br />
                                <input type="text"  onlynumber="5"  decimalPlace="2" placeholder="Enter %" onkeyup="fillPer(this);" class="Ten" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"/>
                            </th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
                </div>
        </div>
        <div class="POuter_Box_Inventory Depdetail" style="text-align: center;">
            <div class="row">
            <input type="button" id="btnSave" value="Save" onclick="Save()" />
                </div>
        </div>
    </div>

</asp:Content>
