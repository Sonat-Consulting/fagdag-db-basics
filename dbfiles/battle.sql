create table game_state (state int);

create or replace procedure usp_Battle1()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------- Steg 1 -----------' ;
        RAISE NOTICE '-- Uønskede Nullverdier -----';
        RAISE NOTICE 'Future-Christian: Hallo';
        RAISE NOTICE 'Future-Christian: Jeg prøver å legge til en ny person.';
        RAISE NOTICE 'Jeg vet ikke hva etternavn han har.  Det gjør sikkert ikke noe at det er blankt..';
        RAISE NOTICE ' ';
        BEGIN
            INSERT INTO person values(3250003, 123456789101112, 4000, 'F',   'Martin',  Null);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Future-Christian: Hmmm.. Det gikk ikke.';
                RAISE NOTICE 'Narrator: Future-Christian lykkes ikke med å fylle databasen med navneløse. Steg fullført';
                INSERT INTO game_state values (1);
                RETURN;
         END;

        RAISE NOTICE 'Narrator: Future-Christian lykkes med å fylle basen med navneløse.   Prøv å hindre dette.';
        ROLLBACK;

    end$$;


create or replace procedure usp_Battle2()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------- Steg 1 -----------' ;

        RAISE NOTICE 'Future-Christian: Jeg har tenkt å legge til Byen min "Slopergrad" ';
        RAISE NOTICE 'Future-Christian: Jeg har ikke noe landkode for den, så jeg legger inn XXX';
        RAISE NOTICE 'Narrator:  Dette er problematisk, vi har rapporter som er avhengig av å kunne koble by og land';

        BEGIN
            INSERT INTO city values (9999,'Slopergrad','XXX','District9',1);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Future-Christian: Uff.. Det gikk ikke heller.';
                RAISE NOTICE 'Narrator: Future-Christian må finne landkoden for å legge inn byer. Basen forblir konsistent.';
                RAISE NOTICE 'Steg fullført.';
                INSERT INTO game_state values (2);
                RETURN;
        END;

        RAISE NOTICE 'Narrator: Future-Christian lykkes med å legge inn byer uten land.';
        RAISE NOTICE 'Dette blir problematisk når man f.eks. skal sammenligne befolkningstall/land vs. befolkningstall totalt.';
        RAISE NOTICE 'Prøv å legge inn et krav om at alle byer skal være i et land  hindre dette.';
        ROLLBACK;


    end$$;



create or replace procedure usp_Battle3()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE 'Not implemented';
        INSERT INTO game_state values (3);

    end$$;

create or replace procedure usp_Battle4()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE 'Not implemented';
        INSERT INTO game_state values (4);

    end$$;

create or replace procedure usp_Battle()
LANGUAGE plpgsql
AS $$
    DECLARE
        state integer;
    BEGIN
        state := (select coalesce(max(game_state.state),0) from game_state);

        CASE state
            when 0 THEN call usp_Battle1(); -- missing not null
            when 1 THEN call usp_Battle2(); -- missing foreign key
            when 2 THEN call usp_Battle3(); -- inserting logical duplicate
            when 3 THEN call usp_Battle4(); -- constraint value
            else
                RAISE Notice 'Du har fullført spillet.  Du har ryddet opp etter Past-Christian og stoppet Future-Christian. ';
                RAISE Notice 'Basen er blitt et tryggere sted!';
                RAISE Notice 'Gratulerer!';
        end case;

    end$$;