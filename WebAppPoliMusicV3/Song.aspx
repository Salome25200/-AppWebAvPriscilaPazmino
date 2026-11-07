
<%@ Page Title="Canciones"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Song.aspx.cs"
    Inherits="WebAppPoliMusicV3.Song" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        body {
            background: #121212;
            color: #ffffff;
        }

        .spotify-wrapper {
            background: linear-gradient(180deg, #242424 0%, #121212 100%);
            border-radius: 20px;
            padding: 35px;
            margin-top: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.45);
        }

        .playlist-badge {
            display: inline-block;
            background: #1DB954;
            color: #121212;
            font-weight: 800;
            padding: 7px 17px;
            border-radius: 999px;
            font-size: 13px;
            margin-bottom: 18px;
        }

        .spotify-title {
            color: #ffffff;
            font-size: 42px;
            font-weight: 800;
            margin-bottom: 15px;
        }

        .spotify-subtitle {
            margin-bottom: 30px;
        }

        .student-label {
            display: block;
            color: #b3b3b3;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 3px;
            margin-bottom: 10px;
        }

        .student-display-name {
            color: #1DB954;
            font-size: clamp(34px, 5vw, 56px);
            font-weight: 900;
            letter-spacing: -1px;
            line-height: 1.2;
            margin-bottom: 12px;
            text-shadow: 0 3px 20px rgba(29,185,84,0.2);
        }

        .student-description {
            color: #b3b3b3;
            font-size: 17px;
            margin-bottom: 0;
        }

        .spotify-message {
            color: #ff6b6b;
            margin-bottom: 18px;
            font-weight: 600;
        }

        .spotify-panel {
            background-color: #181818;
            border-radius: 16px;
            padding: 20px;
            margin-top: 20px;
            overflow-x: auto;
        }

        .song-table {
            width: 100%;
            border-collapse: separate !important;
            border-spacing: 0 10px !important;
            background: transparent;
            color: #ffffff;
        }

        .song-table th {
            background-color: #111111;
            color: #b3b3b3;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none !important;
            padding: 15px 16px !important;
        }

        .song-table td {
            background-color: #282828;
            border: none !important;
            padding: 18px 16px !important;
            vertical-align: middle !important;
            color: #ffffff;
        }

        .song-table tr:hover td {
            background-color: #333333;
            transition: 0.2s ease-in-out;
        }

        .song-id {
            color: #b3b3b3;
            font-weight: 600;
            width: 70px;
        }

        .song-name {
            font-size: 19px;
            font-weight: 750;
            color: #ffffff;
        }

        .song-path {
            color: #b3b3b3;
            font-size: 13px;
            word-break: break-word;
        }

        .song-plays {
            font-weight: 800;
            color: #1DB954;
            font-size: 18px;
        }

        .audio-player {
            width: 260px;
            max-width: 100%;
            border-radius: 30px;
            background-color: #1f1f1f;
        }

        .empty-style {
            background: #282828;
            color: #b3b3b3;
            padding: 20px;
            text-align: center;
        }

        @media (max-width: 767px) {
            .spotify-wrapper {
                padding: 18px;
            }

            .spotify-title {
                font-size: 30px;
            }

            .student-display-name {
                font-size: 34px;
                overflow-wrap: anywhere;
            }
        }
    </style>

    <div class="spotify-wrapper">

        <div class="playlist-badge">
            &#9835; MI BIBLIOTECA MUSICAL
        </div>

        <div class="spotify-subtitle">

            <span class="student-label">
                BIENVENIDA
            </span>

            <div class="student-display-name">
                Priscila.Pazmino
            </div>

            <p class="student-description">
                Disfruta de tu biblioteca musical
            </p>

        </div>

        <h2 class="spotify-title">
            Lista de canciones
        </h2>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="spotify-message">
        </asp:Label>

        <div class="spotify-panel">

            <asp:GridView ID="gvSongs"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="song-table"
                GridLines="None"
                EmptyDataText="No hay canciones registradas."
                ShowHeaderWhenEmpty="True">

                <EmptyDataRowStyle CssClass="empty-style" />

                <Columns>

                    <asp:TemplateField HeaderText="#">
                        <ItemTemplate>
                            <span class="song-id">
                                <%# Eval("ID_SONG") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Nombre">
                        <ItemTemplate>
                            <div class="song-name">
                                <%# Eval("SONG_NAME") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Ruta">
                        <ItemTemplate>
                            <div class="song-path">
                                <%# Eval("SONG_PATH") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Reproducciones">
                        <ItemTemplate>
                            <span class="song-plays">
                                <%# Eval("PLAYS") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Reproducir">
                        <ItemTemplate>
                            <audio controls="controls"
                                   preload="none"
                                   class="audio-player">

                                <source
                                    src='<%# ResolveUrl("~/SongFiles/bensound-adventure.mp3") %>'
                                    type="audio/mpeg" />

                                Tu navegador no soporta audio.

                            </audio>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

    </div>

</asp:Content>
